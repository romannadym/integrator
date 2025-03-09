import { getCookie } from './cookies.js';
document.addEventListener('DOMContentLoaded', function(){
  let csrftoken = getCookie('csrftoken'),
    approve = document.getElementById('approve'),
    deny = document.getElementById('deny'),
    status = document.getElementById('id_appstatuses-0-status'),
    comment_form = document.getElementById('comment-form'),
    modal_deny = document.getElementById('modal-deny'),
    modal_approve = document.getElementById('modal-approve'),
    btn_deny = document.getElementById('btn-deny'),
    btn_approve = document.getElementById('btn-approve'),
    info = document.querySelector('.info-box'),
    text;

  if(typeof(dialog) != 'undefined' && dialog != null){
    text = dialog.querySelector('#dialog-text');
  }

  if(typeof(approve) != 'undefined' && approve != null){
    approve.addEventListener('click', function(){
      modal_approve.style.display = "block";
    });
  }
  if(typeof(deny) != 'undefined' && deny != null){
    deny.addEventListener('click', function(){
      modal_deny.style.display = "block";
    });
  }

  if(typeof(modal_deny) != 'undefined' && modal_deny != null){
    modal_deny.querySelector('.modal-buttons > a + a').addEventListener('click', function(){
      modal_deny.style.display = "none";
    });

    modal_approve.querySelector('.modal-buttons > a + a').addEventListener('click', function(){
      modal_approve.style.display = "none";
    });

    btn_deny.addEventListener('click', function(){
      ChangeStatus(0);
    });

    btn_approve.addEventListener('click', function(){
      ChangeStatus(1);
    });
  }

  function ChangeStatus(approve_status){
    info.textContent = '';
    info.classList.add('hidden');

    let action = (approve_status == 1)?btn_approve.getAttribute('action'):btn_deny.getAttribute('action');

    fetch(action, {
      method: 'PATCH',
      credentials: 'same-origin',
      headers:{
          'Accept': 'application/json',
          'X-CSRFToken': csrftoken,
      },
      })
      .then(response => {
        if(response.status != 200){
          return response.text().then(text => {
            info.classList.remove('blue-info-box', 'hidden');
            info.classList.add('red-info-box');
            info.textContent = text;
            return;
          });
        }
        window.location.reload();
      })
      .catch(error => {
          console.log(error)
      });
  }


  let add_doc = document.getElementById('add-doc');

  if(typeof(add_doc) != 'undefined' && add_doc != null){
  add_doc.addEventListener('click', function(){
    let total = add_doc.closest('form').querySelectorAll('input[id$=-DELETE]').length,
    newF = document.querySelector('.empty-doc').cloneNode(true),
    prefix = 'documents-' + total,
    new_formset;

    newF.innerHTML = newF.innerHTML.replace(/documents-__prefix__/g, 'documents-' + total);

    if(total > 0){
      let formsets = add_doc.closest('form').querySelectorAll('p');

      new_formset = newF.querySelector('p');
      formsets[formsets.length - 1].after(new_formset);
    }
    else{
      new_formset = newF.querySelector('p');
      add_doc.closest('div').before(new_formset);
    }
    total++;

    document.getElementById('id_documents-TOTAL_FORMS').value = total;
    let btn = new_formset.querySelector('.delete-item')
    btn.addEventListener('click', function(){
      btn.closest('p').querySelector('input[type=checkbox]').checked = true;
      btn.closest('p').classList.add('hidden');
    });
  });
}

  if(typeof(comment_form) != 'undefined' && comment_form != null){
    let comment_save_btn = comment_form.querySelector('.btn[type=submit]');
    comment_save_btn.addEventListener('click', function(evn){
      evn.preventDefault();
      comment_save_btn.disabled = true;

      let fData = new FormData(comment_form);

      if(typeof(CKEDITOR) != 'undefined' && CKEDITOR != null){
        for(let instance in CKEDITOR.instances){
          fData.append(instance.replace('id_',''), CKEDITOR.instances[instance].getData());
        }
      }

      fetch(comment_form.getAttribute('action'), {
        method: 'POST',
        credentials: 'same-origin',
        headers:{
            'Accept': 'application/json',
            'X-CSRFToken': csrftoken,
  		  },
  		      body: fData
  		  })
  		  .then(response => {
          window.location.reload();
  		  })
  			.catch(error => {
          console.error('Error:', error);
  		  });
    });
  }
});
