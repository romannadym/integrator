document.addEventListener('DOMContentLoaded', function(){
  function getCookie(name) {
      let cookieValue = null;
      if (document.cookie && document.cookie !== '') {
          const cookies = document.cookie.split(';');
          for (let i = 0; i < cookies.length; i++) {
              const cookie = cookies[i].trim();
              // Does this cookie string begin with the name we want?
              if (cookie.substring(0, name.length + 1) === (name + '=')) {
                  cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                  break;
              }
          }
      }
      return cookieValue;
  }

  let form = document.getElementById('git_form'),
    csrftoken = getCookie('csrftoken');

  form.addEventListener('submit', function(e){
    e.preventDefault();
    let errors = document.getElementById("form_error"),
      message = document.getElementById("form_message");
    errors.classList.add('hidden');
    errors.innerHTML = '';
    message.classList.add('hidden');
    message.textContent = '';


    let fData = new FormData(form);

    fetch('.', {
      method: 'POST',
      credentials: 'same-origin',
      headers:{
          'Accept': 'application/json',
          'X-CSRFToken': csrftoken,
		  },
		      body: fData
		  })
		  .then(response => {
		        return response.json()
		  })
		  .then(data => {
        if(data['message']){
  				message.textContent = data['message'];
  				message.classList.remove('hidden');
  				e.target.reset();
        }
        else{
          try{
               let msgs = JSON.parse(data);
               for(let msg in msgs){
                 for(let m in msgs[msg]){
                   errors.innerHTML += '<p>' + msgs[msg][m].message + '</p>';
                   errors.classList.remove('hidden');
                 }
               }
           }
           catch(e) {
              errors.textContent = data['error'];
     				  errors.classList.remove('hidden');
           }
        }
		  })
			.catch(error => {
        errors.textContent = error;
				errors.classList.remove('hidden');
		  });
});
});
