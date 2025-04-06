import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let contacts = document.getElementById('id_contact'),
    client = document.getElementById('id_client'),
    equipment = document.getElementById('id_equipment'),
    datalist = document.getElementById('equipments'),
    add_btn = document.getElementById('add-doc'),
    del_doc_btn = document.querySelector('.delete-item'),
    submit_btn = document.getElementById('submit-btn'),
    modal = document.getElementById('modal'),
    modal_close = document.getElementById('modal-close'),
    modal_text = modal.querySelector('.modal-text');

  document.addEventListener('click', function(event){
    if(!event.target.matches('.datalist > li') && !event.target.matches('#id_equipment')){
      datalist.classList.remove('active');
    }
    if(event.target.matches('.datalist > li')){
      equipment.value = event.target.textContent;
      datalist.classList.remove('active');
      FilterEquipment();
    }
  });

  equipment.addEventListener('keyup', function(){
    FilterEquipment();
    datalist.classList.add('active');
  });
  equipment.addEventListener('click', function(){
    datalist.classList.toggle('active');
  });

  del_doc_btn.addEventListener('click', function(){
    DeleteFormset(del_doc_btn);
  });

  add_btn.addEventListener('click', function(){
    let emptyForm = document.querySelector('.empty-doc').cloneNode(true),
      new_formset;

    new_formset = emptyForm.querySelector('.pl-30');

    add_btn.closest('div').before(new_formset);

    let del_btn = new_formset.querySelector('.delete-item');
    del_btn.addEventListener('click', function(){
      DeleteFormset(del_btn);
    });
  });

  function DeleteFormset(btn){
    let formset = btn.closest('.pl-30');
    formset.remove();
  }

  function FilterEquipment(){
    let options = datalist.querySelectorAll('li');

    if(options){
      for(let option of options){
        if(equipment.value != ''){
          option.classList.remove('active');
          if(option.textContent.toLowerCase().includes(equipment.value.toLowerCase())){
            option.classList.add('active');
          }
        }
        else{
          option.classList.add('active');
        }
      }
    }
  }

  function ClientsContacts(client_id){
    fetch('../api/clients_contacts/' + client_id, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        return response.json();
    })
    .then(data => {
      for(let contact of data.contacts){
        let option = document.createElement('option');
        option.value = contact.id;
        option.text = contact.fio;
        contacts.appendChild(option);
      }

      for(let equipment of data.equipments){
        let option = document.createElement('li');
        option.textContent = equipment.equipment_name;
        option.setAttribute('data-id', equipment.id);
        option.setAttribute('class', 'active');
        datalist.appendChild(option);
      }
    })
    .catch(error => {
        console.log(error);
    });
  }

  if(typeof(client) != 'undefined' && client != null){
    client.addEventListener('change', function(){
      contacts.innerHTML = '<option value="" selected="">---------</option>';
      equipment.value = '';
      datalist.innerHTML = '';

      if(client.value){
        ClientsContacts(client.value);
      }
    });
  }
  else{
    ClientsContacts(document.getElementById('current-user-id').value);
  }

  modal_close.addEventListener('click', function(){
    modal.style.display = 'none';
  });

  submit_btn.addEventListener('click', function(event){
    event.preventDefault();

    submit_btn.disabled = true;
    modal_text.innerHTML = '';

    let form = document.getElementById('app-form'),
      docs = form.querySelectorAll('input[name=documents]'),
      files_size = 0,
      requires = form.querySelectorAll('[required]'),
      errors = form.querySelectorAll('.error'),
      equip_options = datalist.querySelectorAll('li'),
      equipment_id = 0;

    modal_text.classList.remove('green-text');

    for(let error of errors){
      error.remove();
    }

    for(let field of requires){
      if(!field.value){
        let error = document.createElement('div');
        error.setAttribute('class', 'info-box red-info-box error');
        error.textContent = 'Это поле не может быть пустым';
        field.before(error);

        submit_btn.disabled = false;
        return;
      }
    }

    for(let option of equip_options){
      if(option.textContent == equipment.value){
        equipment_id = option.getAttribute('data-id');
        break;
      }
    }
    if(equipment_id == 0){
      let error = document.createElement('div');
      error.setAttribute('class', 'info-box red-info-box error');
      error.textContent = 'Неверное значение. Выберите оборудование из предложенного списка';
      equipment.before(error);

      submit_btn.disabled = false;
      return;
    }

    for(let doc of docs){
      if(doc.files.length > 0){
        files_size += doc.files[0].size;
      }
    }
    console.log(files_size);

    if(files_size > 52428800){
      modal_text.innerHTML = '<p>Размер файлов превышает 50 Мб!</p>';
      modal.style.display = "block";

      submit_btn.disabled = false;
      return;
    }

    let fData = new FormData(form),
      csrftoken = getCookie('csrftoken');

    fData.set('equipment', equipment_id);
    console.log(fData.getAll('documents'));

    fetch(form.getAttribute('action'), {
      method: 'POST',
      credentials: 'same-origin',
      headers:{
          'Accept': 'application/json',
          'X-CSRFToken': csrftoken,
		  },
		      body: fData
		  })
		  .then(response => {
		    if(response.status != 201){
          return response.text().then(text => {
              modal_text.innerHTML = '<p>' + text + '</p>';
              modal.style.display = "block";
              submit_btn.disabled = false;
              return;
          });
        }
        modal_text.classList.add('green-text');
        modal_text.innerHTML = '<p class="align-center">Заявка принята в работу. Спасибо, что Вы с нами!</p><p class="align-center">С уважением, команда xCloud</p>';
        modal.style.display = "block";
        modal_close.addEventListener('click', function(){
          window.location.replace(document.getElementById("back").value);
        });
		  })
			.catch(error => {
        console.error('Error:', error);
		  });
  });
});
