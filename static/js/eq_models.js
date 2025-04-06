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

  // let brand = document.getElementById('id_brand');
  let brands = document.querySelectorAll('select[id^=id_][id$=-brand]:not([id*=prefix])'),
    csrftoken = getCookie('csrftoken'),
    client = document.getElementById('id_client'),
    organization = document.querySelector('.field-organization .readonly'),
    enddate = document.getElementById('id_enddate');

  for(let brand of brands){
  brand.addEventListener('change', function(){
    let url = document.getElementById('ajax_link').value,
      id = this.value?this.value:0,
      models = this.closest('.inline-related').querySelector('select[id^=id_][id$=-model]'),
      options = models.options;

    models.innerHTML = '<option value="" selected="">---------</option>';

    if(id != 0){
    let fData = new FormData();
    fData.append('pk', id);

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
        result = response.json()
        status_code = response.status;
        if(status_code != 200) {
          console.log(result)
          console.log('Error in getting brand info!')
          return false;
        }
        return result
      })
      .then(result => {
        for(let m of result){
          let opt = document.createElement('option');
          opt.value = m.id;
          opt.innerHTML = m.name;
          models.appendChild(opt);
        }
      })
      .catch(error => {
          console.log(error);
      });
  }
  });

}
  if(typeof(client) != 'undefined' && client != null){
    client.addEventListener('change', function(){
      organization.textContent = '-';
      if(client.value){
        let url = document.getElementById('org_link').value,
          fData = new FormData();
          fData.append('pk', client.value);
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
              result = response.json()
              status_code = response.status;
              if(status_code != 200) {
                console.log(result)
                console.log('Error in getting client info!')
                return false;
              }
              return result
            })
            .then(result => {
              organization.textContent = result.organization;
            })
            .catch(error => {
                console.log(error);
            });
      }
    });
  }

  enddate.addEventListener('change', function(){
    if(this.value != ''){
      let warranties = document.querySelectorAll('input[id^=id_eqcontracts][id$=-warranty]:not([id*=prefix])');
      for(let warranty of warranties){
        if(warranty.value == ''){
          warranty.value = this.value;
        }
      }
    }
  });

  const observer = new MutationObserver(function(mutations_list) {
  	mutations_list.forEach(function(mutation) {
  		mutation.addedNodes.forEach(function(added_node) {
  			if(added_node.classList.contains('inline-related')) {
  				added_node.querySelector('input[id$=-warranty]').value = enddate.value;
  			}
  		});
  	});
  });
  observer.observe(document.querySelectorAll("fieldset")[1], { subtree: false, childList: true });
});
