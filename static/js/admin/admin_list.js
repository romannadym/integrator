import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let checks = document.querySelectorAll('.list-items input[type=checkbox]:not(.check-all)'),
    check_all = document.querySelector('.check-all'),
    del_btn = document.querySelector('.delete-item');

  check_all.addEventListener('change', function(){
    if(this.checked){
      for(let check of checks){
        check.checked = true;
      }
      del_btn.classList.remove('hidden');
    }
    else{
      for(let check of checks){
        check.checked = false;
      }
      del_btn.classList.add('hidden');
    }
  });

  for(let check of checks){
    check.addEventListener('change', function(){
      if(!this.checked && check_all.checked){
        check_all.checked = false;
      }
      let checked = document.querySelectorAll('.list-items input[type=checkbox]:checked');
      checked.length == checks.length?check_all.checked = true:check_all.checked = false;
      checked.length > 0?del_btn.classList.remove('hidden'):del_btn.classList.add('hidden');
    });
  }

  del_btn.addEventListener('click', function(event){
    event.preventDefault();
    let checked = document.querySelectorAll('.list-items input[type=checkbox]:not(.check-all):checked');
    if(checked.length > 0){
      let answer = confirm('Удалить выбранные элементы?');
      if(answer){
        let fData = new FormData(),
          csrftoken = getCookie('csrftoken'),
          errors = document.querySelectorAll('div.error'),
          error_div = document.createElement('div'),
          scroll_div = document.querySelector('.scroll-x'),
          pks = [];

        error_div.setAttribute('class', 'info-box red-info-box error');
        for(let error of errors){
          error.remove();
        }

        for(let check of checked){
          fData.append('id', check.value);
        }

        fetch(del_btn.getAttribute('href'), {
          method: 'POST',
          credentials: 'same-origin',
          headers:{
              'Accept': 'application/json',
              'X-CSRFToken': csrftoken,
    		  },
    		      body: fData
    		  })
          .then(response => {
              if(response.status != 200){
                return response.text().then(text => {
                  error_div.textContent = text;
                  scroll_div.prepend(error_div);
                  return;
                });
              }
              window.location.reload();
          })
          .catch(error => {
              console.log(error);
          });
        }
    }
  });
});
