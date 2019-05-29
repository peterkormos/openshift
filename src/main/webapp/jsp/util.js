function updateMandatoryFieldMark(element)
{
	var font = element.parentNode.getElementsByTagName('FONT')[0]; font.style.color = 'lightGreen'; font.innerHTML = '&#x2713;'; font.size='+2';
}