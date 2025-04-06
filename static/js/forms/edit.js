import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let form = document.querySelector('.form form');

  form.addEventListener('submit', function(event){
    event.preventDefault();

    let fData = new FormData(form),
      formsets = form.querySelectorAll('.formset:not(.hidden)'),
      formset_data = {},
      formset_label = '',
      errors = document.querySelectorAll('div.error'),
      error_div = document.createElement('div'),
      csrftoken = getCookie('csrftoken');

    error_div.setAttribute('class', 'info-box red-info-box error');

    for(let error of errors){
      error.remove();
    }

    if(typeof(CKEDITOR) != 'undefined' && CKEDITOR != null){
      for(let instance in CKEDITOR.instances){
        fData.append(instance.replace('id_',''), CKEDITOR.instances[instance].getData());
      }
    }

    if(formsets.length > 0){
      formset_label = formsets[0].closest('div:not(.formset)').classList.value;

      // for(let key of fData.keys()){
      //    console.log(key);
      //   // if(key.includes(formset_label) && !key.includes('_FORMS')){
      //   //   console.log(key.substring(key.lastIndexOf('-') + 1, key.length));
      //   // }
      // }
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
        // form.querySelector('a.btn').getAttribute('href');
		  });
  });
});
