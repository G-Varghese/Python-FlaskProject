const creditCardInput = document.getElementById('credit-card');

creditCardInput.addEventListener('input', autoFormatCreditCard);

function autoFormatCreditCard(event) {
  const input = event.target.value.replace(/\D/g, '').substring(0, 16);
  const blocks = input.match(/.{1,4}/g) || [];
  const formatted = blocks.join('-');
  event.target.value = formatted;
}