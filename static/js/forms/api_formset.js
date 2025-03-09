document.addEventListener('DOMContentLoaded', function(){
  let add_btns = document.querySelectorAll('.add-item'),
    del_btns = document.querySelectorAll('.delete-item');

  for(let btn of add_btns){
    btn.onclick = function(){
      let prefix = btn.classList.value.replace('add-item', '').trim(),
        emptyForm = document.querySelector('.' + prefix + '.empty-form').cloneNode(true),
        total = document.querySelectorAll('.' + prefix + ' .formset').length,
        new_formset;

      emptyForm.innerHTML = emptyForm.innerHTML.replace('empty-formset', 'formset');

      new_formset = emptyForm.querySelector('.formset');
      btn.before(new_formset);

      let del_btn = new_formset.querySelector('.delete-item');

      del_btn.addEventListener('click', function(){
        del_btn.closest('div').querySelector('input[type=checkbox][name="DELETE"]').checked = true;
        del_btn.closest('div').parentNode.classList.add('hidden');
      });

      total++;

      let formsets = document.querySelectorAll('.' + prefix + ' .formset'),
        lformset = formsets[formsets.length - 1],
        label = lformset.querySelector('.form-grey-line > div').textContent;

      lformset.querySelector('.form-grey-line > div').textContent = label + total;

      lformset.scrollIntoView({behavior: 'smooth'});

    };
  }

  for(let btn of del_btns){
    btn.addEventListener('click', function(){
      btn.closest('div').querySelector('input[type=checkbox][name="DELETE"]').checked = true;
      btn.closest('div').parentNode.classList.add('hidden');
    });
  }
});
