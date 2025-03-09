$(document).ready(function() {
    function getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            document.cookie.split(';').forEach(cookie => {
                cookie = cookie.trim();
                if (cookie.startsWith(name + '=')) {
                    cookieValue = decodeURIComponent(cookie.split('=')[1]);
                }
            });
        }
        return cookieValue;
    }

    let csrftoken = getCookie('csrftoken');
    let equipment = $('#id_equipment');
    let equipmentList = $('#equipments');
    let contacts = $('#id_contact');
    let client = $('#id_client');

    function showEquipmentList() {
        equipmentList.toggle(equipmentList.children().length > 0);
    }

    function hideEquipmentList() {
        setTimeout(() => equipmentList.hide(), 200);
    }

    function SNCheck() {
        let optionFound = equipmentList.children().toArray().some(option => $(option).text() === equipment.val());
        if (!optionFound) {
            equipment[0].setCustomValidity('Выбрано неверное значение');
            equipment[0].reportValidity();
            return false;
        }
        return true;
    }

    function EquipmentList() {
        let clientValue = client.val();
        if ( !clientValue) return;

        $.ajax({
            url: '.',
            method: 'POST',
            data: { client: clientValue, sn: equipment.val() },
            headers: { 'X-CSRFToken': csrftoken },
            dataType: 'json',
            success: function(result) {
                equipmentList.empty();
                result.forEach(eq => {
                    $('<div>', {
                        class: 'option',
                        text: `${eq.equipment__brand__name} ${eq.equipment__model__name} (S/n: ${eq.sn})`,
                        click: function() {
                            equipment.val($(this).text()).get(0).setCustomValidity('');
                            equipmentList.hide();
                        }
                    }).appendTo(equipmentList);
                });
                showEquipmentList();
            }
        });
    }

    equipment.on('input', EquipmentList).on('focus', showEquipmentList).on('blur', hideEquipmentList).on('change', function() {
        if (this.value) SNCheck();
    });
    equipment.on('click', EquipmentList).on('focus', showEquipmentList).on('blur', hideEquipmentList).on('change', function() {
        if (this.value) SNCheck();
    });

    let fileIndex = 0;

    $('#add-doc').on('click', function() {
        let TOTAL_FORMS = $('#id_documents-TOTAL_FORMS');
        let newFileField = `
            <p class="file-upload" id="file-block-${fileIndex}">
                <input type="hidden" name="documents-${fileIndex}-id" id="id_documents-${fileIndex}-id">
                <input type="file" id="id_documents-${fileIndex}-document" name="documents-${fileIndex}-document">
                <label for="id_documents-${fileIndex}-document" >Выбрать</label>
                <span class="file-name">Файл не выбран</span>
                <a href="#" class="delete-item" data-index="${fileIndex}" style="z-index:9999"></a>
            </p>
        `;
        $('#file-list').append(newFileField);
        fileIndex++;
        TOTAL_FORMS.val(fileIndex);
    });

    $(document).on('change', 'input[type="file"]', function() {
        let fileName = this.files[0] ? this.files[0].name : "Файл не выбран";
        let parent = $(this).closest('.file-upload');
        parent.find('.file-name').text(fileName).show();
        parent.find('label').hide();
        parent.find('.delete-item').show();
    });
    $(document).on('click', '.delete-item', function(event) {
    event.preventDefault(); // предотвращаем стандартное поведение ссылки
    console.log('Удаление файла с индексом:', $(this).data('index')); // Отладка: выводим индекс файла
    let index = $(this).data('index');
    $('#file-block-' + index).remove();
    --fileIndex;
    $('#id_documents-TOTAL_FORMS').val(function(i, oldVal) {
    return Math.max(0, oldVal - 1); // Чтобы не уйти в отрицательные значения

    });
});
  /*  $('#add-doc').on('click', function() {
        let total = $('input[id^=id_documents-][id$=-DELETE]').length;
        let newF = $('.empty-doc').clone();
        let prefix = `documents-${total}`;
        newF.html(newF.html().replace(/documents-__prefix__/g, prefix));
        let new_formset = newF.find('p');
        $(this).closest('div').before(new_formset);
        $('#id_documents-TOTAL_FORMS').val(++total);
        new_formset.find('.delete-item').on('click', function() {
            $(this).closest('p').find('input[type=checkbox]').prop('checked', true).end().addClass('hidden');
        });
    });*/

    client.on('change', function() {
        contacts.html('<option value="" selected>---------</option>');
        equipment.val('');
        if (client.val()) {
            $.ajax({
                url: '../get_contacts/',
                method: 'POST',
                data: { client: client.val() },
                headers: { 'X-CSRFToken': csrftoken },
                dataType: 'json',
                success: function(result) {
                    result.forEach(contact => $('<option>', { value: contact.id, text: contact.fio }).appendTo(contacts));
                }
            });
            EquipmentList();
        }
    });

    let modal = $('#modal');
    $('#modal-close').on('click', () => modal.hide());

    $('#app-form').on('submit', function(evn) {
        evn.preventDefault();

        // Блокируем кнопку отправки
        let submitButton = $('#submit-button'); // Убедитесь, что у кнопки отправки есть id='submit-button'
        submitButton.prop('disabled', true);
        submitButton.text('Отправка...'); // Изменяем текст кнопки на "Отправка..."

        let files_size = $('input[id^=id_documents-][id$=-document]').toArray()
            .reduce((sum, doc) => {
                // Проверяем, существует ли загруженный файл и не пустой ли он
                if (doc.files.length > 0) {
                    return sum + doc.files[0].size; // Добавляем размер файла
                }
                return sum; // Если файла нет, возвращаем текущую сумму
            }, 0);

        if (files_size > 52428800) {
            modal.find('.modal-text').html('<p>Размер файлов превышает 50 Мб!</p>').end().show();
            // Разблокируем кнопку
            submitButton.prop('disabled', false);
            submitButton.text('Отправить'); // Восстанавливаем текст кнопки
            return;
        }

        if (!SNCheck()) {
            // Разблокируем кнопку
            submitButton.prop('disabled', false);
            submitButton.text('Отправить'); // Восстанавливаем текст кнопки
            return;
        }

        let formData = new FormData(this);
        $.ajax({
            url: '.',
            method: 'POST',
            data: formData,
            headers: { 'X-CSRFToken': csrftoken },
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function(data) {
                let modalText = modal.find('.modal-text');
                if (data.message == 1) {
                    modalText.addClass('green-text').html('<p class="align-center">Заявка принята в работу. Спасибо, что Вы с нами!</p><p class="align-center">С уважением, команда xCloud</p>');
                    modal.show();
                    $('#modal-close').on('click', () => window.location.replace($('#back').val()));
                } else {
                    let errorText = Object.entries(data).map(([field, msg]) => `<p>"${field}" - ${msg[0]}</p>`).join('');
                    modalText.html(errorText);
                    modal.show();
                }
            },
            error: function() {
                modal.find('.modal-text').html('<p>Произошла ошибка. Попробуйте еще раз.</p>').end().show();
            },
            complete: function() {
                // Разблокируем кнопку после завершения запроса
                submitButton.prop('disabled', false);
                submitButton.text('Отправить'); // Восстанавливаем текст кнопки
            }
        });
    });
});
