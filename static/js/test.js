import { getCookie } from './cookies.js';

let csrftoken = getCookie('csrftoken'),
  btn = document.querySelector('button');

  btn.addEventListener('click', function(evn){
    evn.preventDefault();
    let docs = document.querySelectorAll('input[name=documents]'),
      data = [],
      fData = new FormData();

    for(let doc of docs){
      if(doc.files.length > 0){
        data.push({'document': doc.files[0]});
      }
    }
    fData = new FormData(document.querySelector('form'));

    fetch(document.querySelector('form').getAttribute('action'), {
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
		  .then(data => {
        console.log(data);
		  })
			.catch(error => {
        console.error('Error:', error);
        // btn_submit.disabled = false;
		  });
  });
