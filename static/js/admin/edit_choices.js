document.addEventListener('DOMContentLoaded', function(){
  let btns_left = document.querySelectorAll('.to-the-left'),
    btns_right = document.querySelectorAll('.to-the-right');

  for(let btn of btns_left){
    btn.addEventListener('click', function(){
      let select_right = btn.closest('div').nextElementSibling.querySelector('select'),
        select_left = btn.closest('div').previousElementSibling.querySelector('select'),
        options = select_right.querySelectorAll('option:checked');
      if(options.length > 0){

        for(let option of options){
          select_left.appendChild(option);
        }
      }
    });
  }

  for(let btn of btns_right){
    btn.addEventListener('click', function(){
      let select_right = btn.closest('div').nextElementSibling.querySelector('select'),
        select_left = btn.closest('div').previousElementSibling.querySelector('select'),
        options = select_left.querySelectorAll('option:checked');

        if(options.length > 0){
          for(let option of options){
            option.setAttribute('selected', 'selected');
            select_right.appendChild(option);
          }
        }
    });
  }
});
