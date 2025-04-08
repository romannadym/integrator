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

  let inp = document.getElementById('id_page'),
    csrftoken = getCookie('csrftoken'),
    search_btn = document.getElementById('search-btn'),
    search = document.getElementById('search'),
    pagination = document.querySelector('.pagination')
    lis = pagination.querySelectorAll('li');

  search_btn.addEventListener('click', function(e){
    inp.value = 1;
    PageForm();
  });
  search.addEventListener('keypress', function(e){
     if(event.key === 'Enter'){
       inp.value = 1;
       PageForm();
     }
  });

  document.addEventListener('click', function(e){
    if(e.target.matches('.pagination li')){
      if(e.target.classList.contains('angle-double-left')){
        inp.value = 1;
      }
      else if(e.target.classList.contains('angle-double-right')){
        inp.value = e.target.closest('ul').getAttribute('num_pages');
      }
      else if(parseInt(e.target.innerText)){
        inp.value = e.target.innerText;
      }
      else{
        let num = parseInt(document.querySelector('li.current-page').innerText);
        if(e.target.classList.contains('prev')){
          num--;
        }
        else if(e.target.classList.contains('next')){
          num++;
        }
        inp.value = num;
      }
      PageForm();
    }
  });

  function PageForm(){
    let fData = new FormData(),
      ul = document.querySelector('ul.list-items'),
      // pagination = document.querySelector('.pagination'),
      preloader = document.getElementById('preloader');

    preloader.classList.remove('loaded');

    fData.append('page', inp.value);
    fData.append('search', search.value);

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
        return response.json();
		  })
		  .then(data => {//console.log(data.pagination);
        ul_lis = '';
        ul.innerHTML = '';
        for(let m = 0; m < data.data.length; m++){
          ul_lis += '<li><a target="_blank" href="/articles/' + data.data[m].id + '">' + (data.pagination.number + m + 1) + '. ' + data.data[m].title + '</a></li>';
        }
        ul.innerHTML = ul_lis;

        pagination.setAttribute('num_pages', data.pagination.num_pages);
        if(data.pagination.page > 1){
          pagination.querySelector('.angle-left').classList.remove('hidden');
          (data.pagination.page - 2 > 1)?pagination.querySelector('.angle-double-left').classList.remove('hidden'):pagination.querySelector('.angle-double-left').classList.add('hidden');
        }
        else{
          pagination.querySelector('.angle-left').classList.add('hidden');
          pagination.querySelector('.angle-double-left').classList.add('hidden');
        }

        if(data.pagination.num_pages > data.pagination.page){
          pagination.querySelector('.angle-right').classList.remove('hidden');
          (data.pagination.page + 2 < data.pagination.num_pages)?pagination.querySelector('.angle-double-right').classList.remove('hidden'):pagination.querySelector('.angle-double-right').classList.add('hidden');
        }
        else{
          pagination.querySelector('.angle-right').classList.add('hidden');
          pagination.querySelector('.angle-double-right').classList.add('hidden');
        }
        let pages = pagination.querySelectorAll('.page');
        for(let page of pages){
          page.remove();
        }
        for(let m of data.pagination.range){
          if(m <= data.pagination.page + 2 && m >= data.pagination.page - 2){
            let li = '<li class="page ';
            if(m == data.pagination.page){
              li += 'current-page';
            }
            li += '">' + m + '</li>';
            pagination.querySelector('.angle-right').insertAdjacentHTML('beforebegin', li);
          }
        }

        preloader.classList.add('loaded');
      })
			.catch(error => {
        console.error('Error:', error);
        preloader.classList.add('loaded');
		  });
  }
});
