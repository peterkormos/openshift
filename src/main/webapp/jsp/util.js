function updateMandatoryFieldMark(element)
{
	var font = element.parentNode.getElementsByTagName('FONT')[0]; 
    if (element.value == '' || (element.type == 'checkbox' && !element.checked))
    {
		font.style.color = 'red'; 
		font.innerHTML = '&#8226;'; font.size='+3';
	    return false;
	}
    else 
    {
		font.style.color = 'lightGreen'; 
		font.innerHTML = '&#x2713;'; font.size='+2';
	    return true;
    }
    
}