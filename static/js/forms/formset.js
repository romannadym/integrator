document.addEventListener('DOMContentLoaded', function(){
  let add_btns = document.querySelectorAll('.add-item'),
    del_btns = document.querySelectorAll('.delete-item');

  for(let btn of add_btns){
    btn.onclick = function(){
      let prefix = btn.classList.value.replace('add-item', '').trim(),
        total = document.querySelectorAll('.' + prefix + ' .formset').length,
        emptyForm = document.querySelector('.' + prefix + '.empty-form').cloneNode(true),
        ttl_forms = document.querySelector('input[id=id_' + prefix + '-TOTAL_FORMS]'),
        re = new RegExp(prefix + '-__prefix__', 'g'),
        new_formset;

      emptyForm.innerHTML = emptyForm.innerHTML.replace(re, prefix + '-' + total).replace('empty-formset', 'formset');
      new_formset = emptyForm.querySelector('.formset');

      if(total > 0){
        let formsets = document.querySelectorAll('.' + prefix + ' .formset');
        formsets[formsets.length - 1].after(new_formset);
      }
      else{
        btn.before(new_formset);
      }

      let search_inputs = new_formset.querySelectorAll('.django-select2'),
        del_btn = new_formset.querySelector('.delete-item');

      if (search_inputs.length > 0){
        for(let input of search_inputs){
          input.nextElementSibling.remove();
          input.classList.remove('select2-hidden-accessible');
          $(input).djangoSelect2();
        }
      }

      del_btn.addEventListener('click', function(){
        del_btn.closest('div').querySelector('input[type=checkbox][name$="DELETE"]').checked = true;
        del_btn.closest('div').parentNode.classList.add('hidden');
      });

      total++;
      let formsets = document.querySelectorAll('.' + prefix + ' .formset'),
        lformset = formsets[formsets.length - 1];

      ttl_forms.value = total;
      lformset.scrollIntoView({behavior: 'smooth'});
    };
  }

  if(typeof(del_btns) != 'undefined' && del_btns != null){
    for(let btn of del_btns){
      btn.addEventListener('click', function(){
        btn.closest('div').querySelector('input[type=checkbox][name$="DELETE"]').checked = true;
        btn.closest('div').parentNode.classList.add('hidden');
      });
    }
  }

  let dates = document.querySelectorAll('.date');
  for(let date of dates){
    const picker = new easepick.create({
      element: date,
      css: [
          "/static/css/datepicker.css"
      ],
      lang: 'ru-RU',
      zIndex: 10,
      plugins: [
          "AmpPlugin"
      ],
      AmpPlugin: {
          dropdown: {
              months: true,
              years: true,
              maxYear: (new Date()).getFullYear() + 10,
              minYear: (new Date()).getFullYear() - 10
          }
      },
      format: 'DD.MM.YYYY',
      readonly: false,
    });
  }
});
