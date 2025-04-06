import { getCookie } from '../cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let csrftoken = getCookie('csrftoken'),
    form = document.querySelector('.form form'),
    delete_btn = document.getElementById('delete-contact'),
    modal = document.getElementById("modal"),
    modal_delete = document.getElementById("modal-delete"),
    modal_cancel = document.getElementById("modal-cancel");


  form.addEventListener('submit', function(event){
    event.preventDefault();

    let fData = new FormData(form);

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
        window.location.replace(form.querySelector('a.btn').getAttribute('href'));
		 });
  });

    if(typeof(delete_btn) != 'undefined' && delete_btn != null){
      delete_btn.addEventListener('click', function(){
        modal.style.display = "block";
      });
    }

    if(typeof(modal) != 'undefined' && modal != null){
      modal_cancel.addEventListener('click', function(){
        modal.style.display = "none";
      });

      modal_delete.addEventListener('click', function(){
        fetch(form.getAttribute('action'), {
          method: 'DELETE',
          credentials: 'same-origin',
          headers:{
              'Accept': 'application/json',
              'X-CSRFToken': csrftoken,
    		  },
    		  })
          .then(response => {
              return response.json();
          })
          .then(result => {
            window.location.replace(form.querySelector('a.btn').getAttribute('href'));
          })
          .catch(error => {
              console.log(error)
          });
      });
    }
});
