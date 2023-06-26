const elem = document.getElementById('role');



customer = document.getElementById("preference")
owner =document.getElementById("food_service")

// customer.style.display="none"
owner.style.display="none"

elem.addEventListener('change',drop)

function drop() {

      console.log(elem.value)
      if (elem.value == 'User') {
          customer.style.display="block"
          owner.style.display="none"
      } else if (elem.value == "Owner") {
          customer.style.display="none"
          owner.style.display="block"
      }else{
        customer.style.display="none"
        owner.style.display="none"
      }

  }