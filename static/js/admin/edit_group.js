import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let form = document.querySelector('.form form');

  form.addEventListener('submit', function(event){
    event.preventDefault();

    let fData = new FormData(form),
      csrftoken = getCookie('csrftoken'),
      errors = document.querySelectorAll('div.error'),
      error_div = document.createElement('div'),
      permissions = form.querySelectorAll('#permissions input[type=checkbox]:checked'),
      permissions_ids = [];

    error_div.setAttribute('class', 'info-box red-info-box error');
    for(let error of errors){
      error.remove();
    }

    for(let permission of permissions){
      permissions_ids.push(parseInt(permission.name.replace('permission-', '')))
    }
    fData.append('permissions', JSON.stringify(permissions_ids));

    console.log(fData.getAll('permissions'));

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
});
