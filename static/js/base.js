document.addEventListener('DOMContentLoaded', function(){
  setTimeout(function(){
    document.querySelector('#preloader').classList.add("loaded");
  }, 500);

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

  let notifications = document.querySelector('div.notifications');
  if(typeof(notifications) != 'undefined' && notifications != null){

    document.getElementById('notifications').addEventListener('click', function(){
      if(!notifications.classList.contains('hidden')){
        let lis = notifications.querySelectorAll('.remove-new-notification');
        for(let li of lis){
          li.classList.remove('new-notification', 'remove-new-notification');
        }
      }
      notifications.classList.toggle('hidden');

    });

    let links = notifications.querySelectorAll('li > a'),
      read_all = document.getElementById('read-all');

    for(let link of links){
      link.addEventListener('click', function(e){
        e.preventDefault();
        let input = link.closest('li').querySelector('input'),
          href = link.getAttribute('href');

        if(typeof(input) != 'undefined' && input != null){
          let fData = new FormData(),
            csrftoken = getCookie('csrftoken'),
            url = window.location.origin + '/notifications/';

          fData.append(input.name, input.value);
          fetch(url, {
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
                if(result.message == '1'){
                  window.location.href = href;
                }
        		  })
        			.catch(error => {
                console.error('Error:', error);
        		  });
        }
        else{
          window.location.href = href;
        }
      });
    }

    read_all.addEventListener('click', function(e){
      let form = this.closest('.notification').querySelector('form'),
        fData = new FormData(form),
        csrftoken = getCookie('csrftoken'),
        url = window.location.origin + '/notifications/';

        fetch(url, {
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
            if(result.message == '1'){
              let lis = form.querySelectorAll('.new-notification'),
                inputs = form.querySelectorAll('[name^=notification-]'),
                badge = document.querySelector('#notifications .badge');

              if(typeof(lis) != 'undefined' && lis != null){
                for(let li of lis){
                  li.classList.remove('new-notification');
                  li.classList.add('remove-new-notification');
                }
                for(let input of inputs){
                  input.remove();
                }
                if(typeof(badge) != 'undefined' && badge != null){
                  badge.remove();
                }
              }
            }
      	  })
      		.catch(error => {
            console.error('Error:', error);
      	  });
    });

    document.addEventListener('click', function(e){
      if(!e.target.matches('.notifications p') && !e.target.matches('#notifications') && !e.target.matches('.notifications-count')){
        document.querySelector('div.notifications').classList.add('hidden');

        if(typeof(notifications) != 'undefined' && notifications != null){
          let lis = notifications.querySelectorAll('.remove-new-notification');
          for(let li of lis){
            li.classList.remove('new-notification', 'remove-new-notification');
          }
        }
      }
    });
  }

  let lis = document.querySelectorAll('.admin-base .list-links > li > a:not([href])');
  if(typeof(lis) != 'undefined' && lis != null){
    for(let li of lis){
      li.addEventListener('click', function(){
        let ul = li.closest('li').querySelector('.list-links');
        if(typeof(ul) != 'undefined' && ul != null){
          ul.classList.toggle('hidden');
        }
      });
    }
  }
});
