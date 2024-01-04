const dobInput= document.querySelector('input[type="date"]');
const minAge= 14;

dobInput.addEventListener('change',e => {
  const dob=new Date(e.target.value);
  const ageInMs= Date.now() - dob.getTime();
  const ageDate = new Date(ageInMs);
  const age= Math.abs(ageDate.getUTCFullYear() - 1970)
  if (age < minAge) {
    alert('You must be at least 14 years or older');
    dobInput.value='';
  }
});