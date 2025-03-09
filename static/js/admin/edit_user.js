import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let form = document.querySelector('.form form');

  form.addEventListener('submit', function(event){
    event.preventDefault();

    let fData = new FormData(form),
      csrftoken = getCookie('csrftoken'),
      errors = document.querySelectorAll('div.error'),
      error_div = document.createElement('div'),
      groups = form.querySelectorAll('#groups input[type=checkbox]:checked'),
      groups_ids = [];

    error_div.setAttribute('class', 'info-box red-info-box error');
    for(let error of errors){
      error.remove();
    }

    for(let group of groups){
      groups_ids.push(parseInt(group.name.replace('group-', '')))
    }
    fData.append('groups', JSON.stringify(groups_ids));

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
