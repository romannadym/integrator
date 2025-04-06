document.addEventListener('DOMContentLoaded', function(){
  let table = document.querySelector('#apps-list > tbody'),
    priority = document.getElementById('priority_ids'),
    status = document.getElementById('status_ids'),
    organization = document.getElementById('id_organization'),
    equipment = document.getElementById('id_equipment'),
    engineer = document.getElementById('engineer_ids'),
    mine = document.getElementById('id_mine'),
    opened = document.getElementById('id_opened'),
    page = document.getElementById('id_page'),
    user_id = parseInt(document.getElementById('user_id').value),
    pagination = document.querySelector('.pagination'),
    export_btn = document.getElementById('export-applications'),
    tabs = document.querySelector('.tabs'),
    multi_selects_inputs = document.querySelectorAll('input.multiple-select'),
    filters_inputs = [document.getElementById('id_number'), document.getElementById('id_pubdate')],
    filters_lists = [status],
    filters_checkboxes = [],
    link_for_table = '../api/list/';

  if(typeof(organization) != 'undefined' && organization != null){
    filters_inputs.push(organization);
  }
  if(typeof(equipment) != 'undefined' && equipment != null){
    filters_inputs.push(equipment);
  }

  if(typeof(priority) != 'undefined' && priority != null){
    filters_lists.push(priority);
  }
  if(typeof(engineer) != 'undefined' && engineer != null){
    filters_lists.push(engineer);
  }

  if(typeof(mine) != 'undefined' && mine != null){
    filters_checkboxes.push(mine);
  }
  if(typeof(opened) != 'undefined' && opened != null){
    filters_checkboxes.push(opened);
  }

  for(let input of filters_inputs){
    input.addEventListener('input', function(){
      page.value = 1;
      ApplyFilters(Filters(link_for_table, true));
    });
  }

  for(let list of filters_lists){
    list.querySelector('.btn').addEventListener('click', function(){
      list.classList.remove('active');
      page.value = 1;
      ApplyFilters(Filters(link_for_table, true));
    });

    let checks = list.querySelectorAll('input[type=checkbox]'),
      links = list.querySelectorAll('li > a');

    for(let check of checks){
      check.addEventListener('change', function(){
        let checked = list.querySelectorAll('input[type=checkbox]:checked');
        if(this.checked){
          if(this.value == 'all'){
            for(let ch of checked){
              if(ch !== check){
                ch.checked = false;
              }
            }
          }
          else{
            list.querySelector('input[value=all]').checked = false;
          }
        }
      });
    }

    for(let link of links){
      link.addEventListener('click', function(){
        let box = link.closest('li').querySelector('input[type=checkbox]');
        box.checked = !box.checked;

        let evnt = new Event('change');
        box.dispatchEvent(evnt);
      });
    }
  }

  for(let checkbox of filters_checkboxes){
    checkbox.addEventListener('change', function(){
      page.value = 1;
      ApplyFilters(Filters(link_for_table, true));
    });
  }

  for(let input of multi_selects_inputs){
    input.addEventListener('click', function(){
      document.getElementById(input.getAttribute('data-target')).classList.toggle('active');
    });
  }

  document.addEventListener('click', function(event){
    if(!event.target.matches('.multiple-select') && !event.target.matches('.multiple-select input') && !event.target.matches('.multiple-select .btn') && !event.target.matches('.multiple-select > li > a')){
      let selects = document.querySelectorAll('ul.multiple-select');
      for(let select of selects){
        select.classList.remove('active');
      }
    }
    if(event.target.matches('.pagination li')){
      if(event.target.classList.contains('angle-double-left')){
        page.value = 1;
      }
      else if(event.target.classList.contains('angle-double-right')){
        page.value = event.target.closest('ul').getAttribute('num_pages');
      }
      else if(parseInt(event.target.innerText)){
        page.value = event.target.innerText;
      }
      else{
        let num = parseInt(document.querySelector('li.current-page').innerText);
        if(event.target.classList.contains('prev')){
          num--;
        }
        else if(event.target.classList.contains('next')){
          num++;
        }
        page.value = num;
      }
      ApplyFilters(Filters(link_for_table, true));
    }
  });

  if(typeof(export_btn) != 'undefined' && export_btn != null){
    export_btn.addEventListener('click', function(){
      let excel_link = Filters('../api/list_to_excel/', false);

      window.location = excel_link;
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
  }

  function Filters(link, add_page){
    let params = '';

    for(let input of filters_inputs){
      if(input.value.trim() != ''){
        params += '&' + input.name + '=' + input.value.trim();
      }
    }

    for(let list of filters_lists){
      let elms = list.querySelectorAll('input[type="checkbox"]:checked');
      if(elms.length > 0){
        params += '&' + list.id + '=';
        for(let elm of elms){
          params += elm.value + '|';
        }
      }
    }

    for(let checkbox of filters_checkboxes){
      if(checkbox.checked){
        params += '&' + checkbox.name + '=1';
      }
    }

    if(add_page){
      params += '&page=' + page.value;
    }

    if(params != ''){
      link += '?' + params.slice(1)
    }

    return link;
  }

  function ApplyFilters(link){
    table.innerHTML = '';

    fetch(link, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        return response.json();
    })
    .then(data => {
      let trs = '',
        general_link = 'details';
      if(data.permissions.is_staff){
        general_link = 'edit';
      }

      general_link = '/applications/' + general_link + '/';
      for(let application of data.applications){
        let application_link = general_link + application.id;
        let problem = application.problem.length > 200
        ? application.problem.slice(0, 200) + "..." // Обрезаем и добавляем многоточие
    : application.problem; // Если строка короче 400 символов, оставляем без изменений
        trs += '<tr';
        if(user_id == parseInt(application.engineer_id)){
          trs += ' class="bg-middle-grey"';
        }

        trs += '><td><a href="' + application_link + '">' + application.id + '</a></td>';
        trs += '<td><a href="' + application_link + '">' + application.formatted_date + '</a></td>';
        if(data.permissions.is_staff){
          trs += '<td><a href="' + application_link + '">' + application.priority_name + '</a></td>' +
          '<td><a href="' + application_link + '">' + application.organization_name + '</a></td>' +
          '<td><a href="' + application_link + '">' + application.end_user_organization_name + '</a></td>';
        }
        trs += '<td><a href="' + application_link + '">' + application.equipment_name + '</a></td><td';
        if(application.status_id == 1){
          trs += ' class="green-text"';
        }
        else if(application.status_id == 4){
          trs += ' class="red-text"';
        }
        trs += '><a href="' + application_link + '">' + application.status_name + '</a></td>' +
        '<td class="details-width"><a href="' + application_link + '" >' + problem + '</a></td>';
        if(data.permissions.is_staff){
          trs += '<td><a href="' + application_link + '">' + application.engineer_name + '</a></td>';
        }
        trs += '</tr>';
      }
      table.innerHTML = trs;

      if(data.pagination.has_previous){
        pagination.querySelector('.angle-left').classList.remove('hidden');
        (data.pagination.page - 2 > 1)?pagination.querySelector('.angle-double-left').classList.remove('hidden'):pagination.querySelector('.angle-double-left').classList.add('hidden');
      }
      else{
        pagination.querySelector('.angle-left').classList.add('hidden');
        pagination.querySelector('.angle-double-left').classList.add('hidden');
      }
      if(data.pagination.has_next){
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
      for(let m of data.pagination.pages_range){
        if(m <= data.pagination.page + 2 && m >= data.pagination.page - 2){
          let li = '<li class="page ';
          if(m == data.pagination.page){
            li += 'current-page';
          }
          li += '">' + m + '</li>';
          pagination.querySelector('.angle-right').insertAdjacentHTML('beforebegin', li);
        }
      }
    })
    .catch(error => {
        console.log(error);
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
          page.value = 1;
          ApplyFilters(Filters(link_for_table, true));
        });
        picker.on('clear', (e) => {
          page.value = 1;
          ApplyFilters(Filters(link_for_table, true));
        });
      }
    });
});
