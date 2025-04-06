import { getCookie } from './cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let csrftoken = getCookie('csrftoken'),
    delete_btn = document.getElementById('delete-app'),
    return_btn = document.getElementById('return-app'),
    modal = document.getElementById("modal"),
    return_modal = document.getElementById("return-modal"),
    modal_delete = document.getElementById("modal-delete"),
    modal_cancel = document.getElementById("modal-cancel"),
    modal_return = document.getElementById("modal-return"),
    del_btns = document.querySelectorAll('.delete-item'),
    spare = document.getElementById('id_spares'),
    problem = document.getElementById('id_problem'),
    equipment = document.getElementById('id_equipment'),
    comment_form = document.getElementById('comment-form'),
    back_link = document.querySelector('.back-link').getAttribute('href'),
    datalist,
    spare_datalist;

  if(typeof(equipment) != 'undefined' && equipment != null){
    datalist = equipment.list;
  }

  if(typeof(spare) != 'undefined' && spare != null){
    spare_datalist = spare.list;
  }
    // spares = document.getElementById('id_spares');

  if(typeof(delete_btn) != 'undefined' && delete_btn != null){
    delete_btn.addEventListener('click', function(){
      modal.style.display = "block";
    });
  }

  if(typeof(return_btn) != 'undefined' && return_btn != null){
    return_btn.addEventListener('click', function(){
      return_modal.style.display = "block";
    });
  }

  if(typeof(modal) != 'undefined' && modal != null){
    modal_cancel.addEventListener('click', function(){
      modal.style.display = "none";
    });

    modal_delete.addEventListener('click', function(){
      fetch(modal_delete.getAttribute('action'), {
        method: 'DELETE',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'X-CSRFToken': csrftoken,
  		  },
  		  })
        .then(response => {
            if(response.status != 200){
              return response.text().then(text => {
                alert(text);
                return;
              });
            }
            window.location.replace('/applications/apps_list/');
        })
        .catch(error => {
            console.log(error)
        });
    });
  }

  if(typeof(return_modal) != 'undefined' && return_modal != null){
    return_modal.querySelector('.modal-buttons > a + a').addEventListener('click', function(){
      return_modal.style.display = "none";
    });

    modal_return.addEventListener('click', function(){
      fetch(modal_return.getAttribute('action'), {
        method: 'PATCH',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'X-CSRFToken': csrftoken,
  		  },
  		  })
        .then(response => {
          if(response.status != 200){
            return response.text().then(text => {
              alert(text);
              return;
            });
          }
          window.location.reload();
        })
        .catch(error => {
            console.log(error)
        });
    });
  }

  if(typeof(comment_form) != 'undefined' && comment_form != null){
    let comment_save_btn = comment_form.querySelector('.btn[type=submit]');
    comment_save_btn.addEventListener('click', function(evn){
      evn.preventDefault();
      comment_save_btn.disabled = true;
      let fData = new FormData(comment_form);

      if(typeof(CKEDITOR) != 'undefined' && CKEDITOR != null){
        for(let instance in CKEDITOR.instances){
          fData.append(instance.replace('id_',''), CKEDITOR.instances[instance].getData());
        }
      }

      fetch(comment_form.getAttribute('action'), {
        method: 'POST',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'X-CSRFToken': csrftoken,
  		  },
  		      body: fData
  		  })
  		  .then(response => {
          window.location.reload();
  		  })
  			.catch(error => {
          console.error('Error:', error);
  		  });
    });
  }

  // function CheckSpareQuantity(spare_id = null){
  //   let form = spares.closest('form'),
  //     exists = form.querySelectorAll('.exists[spare="' + spares.value + '"] input[type=checkbox]:checked'),
  //     new_spare = form.querySelectorAll('p[spare="' + spares.value + '"]:not(.exists) input[type=checkbox]:not(:checked)'),
  //     fData = new FormData();
  //   if(spare_id == null){
  //     fData.append('spare', spares.value);
  //   }
  //   else{
  //     fData.append('spare', spare_id);
  //   }
  //
  //   fetch('/applications/get_spare_quantity/', {
  //     method: 'POST',
  //     credentials: 'same-origin',
  //     headers:{
  //         'Accept': 'application/json',
  //         'X-CSRFToken': csrftoken,
  //     },
  //         body: fData
  //     })
  //     .then(response => {
  //         return response.json();
  //     })
  //     .then(result => {
  //       let total = result.quantity - new_spare.length + exists.length;
  //       if(spare_id == null){
  //         if(total <= 0){
  //           spares.options[spares.selectedIndex].remove();
  //         }
  //       }
  //       else{
  //         let opt = spares.querySelector('option[value="' + spare_id + '"]');
  //         if(total > 0 && (typeof(opt) == 'undefined' || opt == null)){
  //           opt = document.createElement('option');
  //           opt.value = spare_id;
  //           opt.innerHTML = result.name;
  //           spares.appendChild(opt);
  //         }
  //       }
  //     })
  //     .catch(error => {
  //         console.log(error);
  //     });
  // }

  function SparesList(){
    let options = spare_datalist.options;

    for(let option of options){
      if(spare.value === option.value){
        return;
      }
    }
    spare_datalist.innerHTML = '';

    if(spare.value){
      let fData = new FormData();
      fData.append('spare', spare.value);

      fetch('../get_spares_list/', {
        method: 'POST',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'X-CSRFToken': csrftoken,
  		  },
  		      body: fData
  		  })
        .then(response => {
            return response.json();
        })
        .then(result => {
          for(let spare of result){
            let option = document.createElement('option');
            option.value = spare.pk;
            option.text = spare.name + ' (S/n: ' + spare.sn + ')';
            spare_datalist.appendChild(option);
          }
        })
        .catch(error => {
            console.log(error);
        });
    }
  }


  let fileIndex = $('#id_documents-TOTAL_FORMS').val();

  $('#add-doc').on('click', function() {
      let TOTAL_FORMS = $('#id_documents-TOTAL_FORMS');


      let newFileField = `
          <p class="file-upload" id="file-block-${fileIndex}">
              <input type="hidden" name="documents-${fileIndex}-id" id="id_documents-${fileIndex}-id">
              <input type="hidden" name="documents-${fileIndex}-name" id="id_documents-${fileIndex}-name">
              <input type="file" id="id_documents-${fileIndex}-document" name="documents-${fileIndex}-document">
              <label for="id_documents-${fileIndex}-document" >Выбрать</label>
              <span class="file-name">Файл не выбран</span>
              <a href="#" class="delete-item" data-index="${fileIndex}" style="z-index:9999"></a>
              <input type="checkbox" name="documents-${fileIndex}-DELETE" id="id_documents-${fileIndex}-DELETE" class="hidden">
          </p>
      `;
    $('#file-list').append(newFileField);
      ++fileIndex;
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
    if ($(this).attr('data-index') !== undefined) {
      console.log('Удаление файла с индексом:', $(this).data('index')); // Отладка: выводим индекс файла
      let index = $(this).data('index');
      $('#file-block-' + index).remove();
      --fileIndex;
      $('#id_documents-TOTAL_FORMS').val(function(i, oldVal) {
      return Math.max(0, oldVal - 1); // Чтобы не уйти в отрицательные значения
      });
    } else {
        $(this).closest('p').find('input[type=checkbox]').prop('checked', true);
        $(this).closest('p').hide();
    }


});

  /*if(typeof(del_btns) != 'undefined' && del_btns != null){
    for(let btn of del_btns){
      btn.addEventListener('click', function(){
        btn.closest('p').querySelector('input[type=checkbox]').checked = true;
        btn.closest('p').classList.add('hidden');

        if(btn.closest('p').querySelector('input[type=checkbox]').id.indexOf('appeqspare') !== - 1){
          // CheckSpareQuantity(btn.closest('p').getAttribute('spare'));
        }
      });
    }
  }*/


 /*let add_doc = document.getElementById('add-doc');

  if(typeof(add_doc) != 'undefined' && add_doc != null){

    add_doc.addEventListener('click', function(){
      let total = add_doc.closest('form').querySelectorAll('input[id$=-DELETE]').length,
      newF = document.querySelector('.empty-doc').cloneNode(true),
      prefix = 'documents-' + total,
      new_formset;

      newF.innerHTML = newF.innerHTML.replace(/documents-__prefix__/g, 'documents-' + total);

      if(total > 0){
        let formsets = add_doc.closest('form').querySelectorAll('p');

        new_formset = newF.querySelector('p');
        formsets[formsets.length - 1].after(new_formset);
      }
      else{
        new_formset = newF.querySelector('p');
        add_doc.closest('div').before(new_formset);
      }
      total++;

      document.getElementById('id_documents-TOTAL_FORMS').value = total;
      let btn = new_formset.querySelector('.delete-item')
      btn.addEventListener('click', function(){
        btn.closest('p').querySelector('input[type=checkbox]').checked = true;
        btn.closest('p').classList.add('hidden');
      });
    });
  }*/

  if(typeof(spare) != 'undefined' && spare != null){
    spare.addEventListener('input', function(){
      SparesList();
    });
    spare.addEventListener('change', function(){
      SparesList();
    });

    let add_spare = document.getElementById('add-spare');

    add_spare.addEventListener('click', function(){
      if(spare.value){
        let form = spare.closest('form'),
        total = form.querySelectorAll('input[id$=-DELETE]').length,
        newF = document.querySelector('.empty-spare').cloneNode(true),
        prefix = 'appeqspare-' + total,
        new_formset;

        newF.innerHTML = newF.innerHTML.replace(/appeqspare-__prefix__/g, 'appeqspare-' + total);

        if(total > 0){
          let formsets = form.querySelectorAll('p');
          new_formset = newF.querySelector('p');
          formsets[formsets.length - 1].after(new_formset);
        }
        else{
          new_formset = newF.querySelector('p');
          spare.closest('div').after(new_formset);
        }
        new_formset.setAttribute('spare', spare.value);
        new_formset.querySelector('input[id=id_appeqspare-' + total + '-spare]').value = spare.value;
        total++;

        document.getElementById('id_appeqspare-TOTAL_FORMS').value = total;
        new_formset.querySelector('.delete-item').before(spare_datalist.querySelector('option[value="' + spare.value + '"]').label);


        let btn = new_formset.querySelector('.delete-item')
        btn.addEventListener('click', function(){
          btn.closest('p').querySelector('input[type=checkbox]').checked = true;
          btn.closest('p').classList.add('hidden');
          // CheckSpareQuantity(btn.closest('p').getAttribute('spare'));
        });

        // CheckSpareQuantity();
      }
    });
  }

  function SNCheck(){
    var optionFound = false,
      datalist = equipment.list,
      options = datalist.options;

    for(let option of options){
      if(equipment.value === option.value){
        optionFound = true;
        break;
      }
    }

    if(!optionFound){
      equipment.setCustomValidity('Выбрано неверное значение');
      equipment.reportValidity();
      return false;
    }
    return true;
  }

  let called = false;

  function EquipmentList(){
    if(called){
      return;
    }
    called = true;
    let options = datalist.options;

    for(let option of options){
      if(equipment.value === option.value){
        return;
      }
    }
    datalist.innerHTML = '';
    document.getElementById('confs').innerHTML = '';

    if(equipment.value){
      let fData = new FormData();
      fData.append('pk', delete_btn.getAttribute('app_pk'));
      fData.append('sn', equipment.value);

      fetch('../get_eqs_in_edit/', {
        method: 'POST',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'X-CSRFToken': csrftoken,
  		  },
  		      body: fData
  		  })
        .then(response => {
            return response.json();
        })
        .then(result => {
          // console.log(result);
          for(let eq of result){
            let option = document.createElement('option');
            option.value = eq.equipment__brand__name + ' ' + eq.equipment__model__name + ' (S/n: ' + eq.sn + ')';
            datalist.appendChild(option);
            if(eq.conf){
              document.getElementById('confs').innerHTML = eq.conf;
            }
          }
          called = false;
        })
        .catch(error => {
            console.log(error);
            called = false;
        });
    }
    else{
      called = false;
    }
  }
  if(typeof(equipment) != 'undefined' && equipment != null){
    equipment.addEventListener('input', function(){
      EquipmentList();
    });
    equipment.addEventListener('change', function(){
      EquipmentList();

      if(this.value != ''){
        let eq_check = SNCheck();
        if(!eq_check){
          return;
        }
      }
    });
  }
});
