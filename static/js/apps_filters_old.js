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

  document.addEventListener('click', function(e){
    if(!e.target.matches('.multiple-select') && !e.target.matches('.multiple-select input') && !e.target.matches('.multiple-select .btn') && !e.target.matches('.multiple-select > li > a')){
      let selects = document.querySelectorAll('ul.multiple-select');
      for(let select of selects){
        select.classList.remove('active');
      }
    }
    if(e.target.matches('.pagination li')){
      let inp = document.getElementById('id_page');
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
      filterForm();
    }
  });

  let csrftoken = getCookie('csrftoken'),
    form = document.getElementById('filters-form'),
    table = document.querySelector('#apps-list > tbody'),
    priority = document.getElementById('id_priority'),
    status = document.getElementById('id_status'),
    organization = document.getElementById('id_organization'),
    equipment = document.getElementById('id_equipment'),
    engineer = document.getElementById('id_engineer'),
    mine = document.getElementById('id_mine'),
    opened = document.getElementById('id_opened'),
    tabs = document.querySelector('.tabs'),
    multi_selects = document.querySelectorAll('input.multiple-select'),
    uls_select = document.querySelectorAll('ul.multiple-select'),
    pagination = document.querySelector('.pagination');

  function filterForm(){
    table.innerHTML = '';
    // pagination.innerHTML = '';

    let fData = new FormData(form);
    if(typeof(mine) != 'undefined' && mine != null && mine.checked){
      fData.append('mine', mine.checked);
    }
    if(typeof(opened) != 'undefined' && opened != null && opened.checked){
      fData.append('opened', opened.checked);
    }
    if(typeof(priority) != 'undefined' && priority != null){
      let vals = '',
        lis = priority.querySelectorAll('input[type="checkbox"]:checked');
      for(let li of lis){
        vals += li.value + '|';
      }
      if(vals == ''){
        vals = '|';
      }
      fData.append('priority', vals);
    }

    let statuses = '',
      sts = status.querySelectorAll('input[type="checkbox"]:checked');
    for(let st of sts){
      statuses += st.value + '|';
    }
    if(statuses == ''){
      statuses = '|';
    }
    fData.append('status', statuses);

    if(typeof(engineer) != 'undefined' && engineer != null){
      let vals = '',
        lis = engineer.querySelectorAll('input[type="checkbox"]:checked');
      for(let li of lis){
        vals += li.value + '|';
      }
      if(vals == ''){
        vals = '|';
      }
      fData.append('engineer', vals);
    }

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
		  .then(data => {
        let link = 'details';
        if(typeof(priority) != 'undefined' && priority != null){
          link = 'edit';
        }
        table_data = '';
        for(let m = 0; m < data.data.length; m++){
          table_data += '<tr><td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].id +
          '</a></td><td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].appdate + '</a></td>';
          if(typeof(priority) != 'undefined' && priority != null){
            table_data += '<td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].apriority + '</a></td>';
          }
          if(typeof(organization) != 'undefined' && organization != null){
            table_data += '<td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].organization + '</a></td><td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].end_user + '</a></td>';
          }
          table_data += '<td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].equip +
          '</a></td><td class="' + data.data[m].color + '"><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].stat + '</a></td>';
          if(typeof(priority) != 'undefined' && priority != null){
            table_data += '<td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].problem +
            '</a></td><td><a href="/applications/' + link + '/' + data.data[m].id + '">' + data.data[m].eng + '</a></td>';
          }
          table_data += '</tr>';
        }
        table.innerHTML = table_data;

        if(data.prev){
          pagination.querySelector('.angle-left').classList.remove('hidden');
          (data.number - 2 > 1)?pagination.querySelector('.angle-double-left').classList.remove('hidden'):pagination.querySelector('.angle-double-left').classList.add('hidden');
        }
        else{
          pagination.querySelector('.angle-left').classList.add('hidden');
          pagination.querySelector('.angle-double-left').classList.add('hidden');
        }

        if(data.next){
          pagination.querySelector('.angle-right').classList.remove('hidden');
          (data.number + 2 < data.num_pages)?pagination.querySelector('.angle-double-right').classList.remove('hidden'):pagination.querySelector('.angle-double-right').classList.add('hidden');
        }
        else{
          pagination.querySelector('.angle-right').classList.add('hidden');
          pagination.querySelector('.angle-double-right').classList.add('hidden');
        }
        let pages = pagination.querySelectorAll('.page');
        for(let page of pages){
          page.remove();
        }
        for(let m of data.range){
          if(m <= data.number + 2 && m >= data.number - 2){
            let li = '<li class="page ';
            if(m == data.number){
              li += 'current-page';
            }
            li += '">' + m + '</li>';
            pagination.querySelector('.angle-right').insertAdjacentHTML('beforebegin', li);
          }
        }

      })
			.catch(error => {
        console.error('Error:', error);
		  });
  }

  const picker = new easepick.create({
    element: "#id_pubdate",
    css: [
        "/static/css/datepicker.css"
    ],
    lang: 'ru-RU',
    zIndex: 10,
    plugins: [
        "RangePlugin",
        "AmpPlugin"
    ],
    AmpPlugin: {
        dropdown: {
            months: true,
            years: true
        },
        resetButton: true,
    },
    format: 'DD.MM.YYYY',
    readonly: false,
    setup(picker) {
      picker.on('select', (e) => {
        filterForm();
      });
      picker.on('clear', (e) => {
        filterForm();
      });
    }
  });

  document.getElementById('id_number').addEventListener('input', function(){
    filterForm();
  });

  status.querySelector('.btn').addEventListener('click', function(){
    status.classList.remove('active');
    filterForm();
  });

  if(typeof(priority) != 'undefined' && priority != null){
    priority.querySelector('.btn').addEventListener('click', function(){
      priority.classList.remove('active');
      filterForm();
    });
  }

  if(typeof(organization) != 'undefined' && organization != null){
    organization.addEventListener('input', function(){
      filterForm();
    });
  }

  if(typeof(equipment) != 'undefined' && equipment != null){
    equipment.addEventListener('input', function(){
      filterForm();
    });
  }
  if(typeof(engineer) != 'undefined' && engineer != null){
    engineer.querySelector('.btn').addEventListener('click', function(){
      engineer.classList.remove('active');
      filterForm();
    });
  }
  if(typeof(mine) != 'undefined' && mine != null){
    mine.addEventListener('change', function(){
      filterForm();
    });
  }
  if(typeof(opened) != 'undefined' && opened != null){
    opened.addEventListener('change', function(){
      filterForm();
    });
  }

  for(let elm of uls_select){
    let checks = elm.querySelectorAll('input[type=checkbox]');
    for(let check of checks){
      check.addEventListener('change', function(){
        let checked = elm.querySelectorAll('input[type=checkbox]:checked');
        if(this.checked){
          if(this.value == 'all'){
            for(let ch of checked){
              if(ch !== check){
                ch.checked = false;
              }
            }
          }
          else{
            elm.querySelector('input[value=all]').checked = false;
          }
        }
      });
    }
  }

  for(let elm of multi_selects){
    elm.addEventListener('click', function(){
      document.getElementById(elm.getAttribute('data-target')).classList.toggle('active');
    });
  }
  let ms_links = document.querySelectorAll('.multiple-select > li > a');
  for(let ms_link of ms_links){
    ms_link.addEventListener('click', function(){
      let box = ms_link.closest('li').querySelector('input[type=checkbox]');
      box.checked = !box.checked;
      let evnt = new Event('change');
      box.dispatchEvent(evnt);
    });
  }

  if(typeof(tabs) != 'undefined' && tabs != null){
    let tabs_a = tabs.querySelectorAll('a:not(#change_password)'),
      tabs_contents = document.querySelectorAll('.tab-content');

    for(let tab of tabs_a){
      tab.addEventListener('click', function(){
        tabs.querySelector('a.active').classList.remove('active');
        this.classList.add('active');
        for(let content of tabs_contents){
          content.classList.add('hidden');
        }
        let contents = document.querySelectorAll('.' + this.id);
        for(let content of contents){
          content.classList.remove('hidden');
        }
      });
    }

    let links = document.querySelectorAll('.tab-equipments .contract');
    for(let a of links){
      a.addEventListener('click', function(){
        let ol = a.nextElementSibling;
        if(typeof(ol) != 'undefined' && ol != null){
          ol.classList.toggle('hidden');
        }
      });
    }

    let equips = document.querySelectorAll('.tab-equipments .contract-equip');
    for(let equip of equips){
      equip.addEventListener('click', function(){
        equipment.value = equip.getAttribute('equip');
        filterForm();
        document.getElementById('tab-apps').click();
      });
    }
  }
});
