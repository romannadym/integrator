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

  let brands = document.getElementById('id_brand'),
    models = document.getElementById('id_model'),
    csrftoken = getCookie('csrftoken');

  brands.addEventListener('change', function(){
    models.innerHTML = '<option value="" selected="">---------</option>';

    if(brands.value){
      let fData = new FormData();
      fData.append('brand', brands.value);

      fetch(window.location.origin + '/applications/spare_models/', {
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

  models.addEventListener('change', function(){
    let pns = document.querySelectorAll('datalist[id^=id_pnspare-][id$=-number_list]:not([id*=prefix])');
    for(let pn of pns){
      pn.innerHTML = '';
    }
    if(models.value){
      let fData = new FormData();
      fData.append('model', models.value);

      fetch(window.location.origin + '/applications/model_pns/', {
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

            for(let pn of pns){
              pn.innerHTML += '<option value="' + m + '"></option>';
            }
          }
        })
        .catch(error => {
            console.log(error);
        });
    }


  });


  // document.getElementById('pnspare-group').addEventListener('DOMNodeInserted', function(e){
  //   if(e.target.nodeName.toLowerCase() == 'div' && e.target.id.indexOf('pnspare-') > -1){
  //
  //   }
  // });
});
