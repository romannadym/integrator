import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let form = document.querySelector('.form form');

  form.addEventListener('submit', function(event){
    event.preventDefault();

    let fData = new FormData(),
      csrftoken = getCookie('csrftoken'),
      errors = document.querySelectorAll('div.error'),
      error_div = document.createElement('div'),
      form_fields = form.querySelectorAll('[name]:not(.formset *)'),
      add_links = form.querySelectorAll('.add-item');

    error_div.setAttribute('class', 'info-box red-info-box error');

    for(let error of errors){
      error.remove();
    }

    for(let field of form_fields){
      let value = get_field_value(field);
      fData.append(field.name, value);
    }

    for(let link of add_links){
      let formset_label = link.classList[1],
        formsets = form.querySelectorAll('.' + formset_label + ' .formset'),
        formsets_data = [];

      for(let formset of formsets){
        let fields = formset.querySelectorAll('input, select, textarea'),
          field_arr = {};

        for(let field of fields){
          if(field.hasAttribute('required') && !field.value){
            error_div.textContent = 'Необходимо заполнить';
            field.closest('div').prepend(error_div);
            return;
          }
          else{
            field_arr[field.name] = get_field_value(field);
          }
        }
        formsets_data.push(field_arr);
      }
      fData.append(formset_label, JSON.stringify(formsets_data));
    }

    fetch(form.getAttribute('action'), {
      method: form.getAttribute('method'),
      credentials: 'same-origin',
      headers:{
          'Accept': 'application/json',
          'X-CSRFToken': csrftoken,
		  },
		      body: fData
		  })
		  .then(response => {
        if(response.status != 201 && response.status != 200){
          return response.text().then(text => {
            error_div.textContent = text;
            form.prepend(error_div);
            return;
          });
        }

        let back_link = form.querySelector('button[type=submit] + .btn').getAttribute('href');
        window.location.href = back_link;
		  });
  });

  function get_field_value(field){
    let value = '';

    if(field.type == 'checkbox'){
      value = field.checked;
    }
    else if(field.type == 'file'){
      let clear = field.closest('div').querySelector('[name$=clear]');
      if(typeof(clear) != 'undefined' && clear != null && clear.checked){
        value = '';
      }
      else if(field.files[0]){
        value = field.files[0];
      }
    }
    else{
      value = field.value;
    }

    return value;
  }
});
