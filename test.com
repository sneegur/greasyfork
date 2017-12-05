// ==UserScript==
// @name        test
// @namespace   test.com
// @description test
// @include     https://firetest.ru/Disciplines/DisciplineTest
// @version     1
// @grant       none
// ==/UserScript==
// allow pasting

if (window.File && window.FileReader && window.FileList && window.Blob) {
  // –аботает
} else {
  alert('File API не поддерживаетс€ данным браузером');
}

var GlobalText = '';

var inp = document.createElement('input');
inp.type = "file";
inp.id = "puttyY"
document.getElementsByTagName('body')[0].appendChild(inp);

function handleFileSelect(evt){
  var files = evt.target.files;
  
  var reader = new FileReader();
  
  reader.onload = function(file){
    var resultText = file.target.result;
    GlobalText = resultText;
    alert(GlobalText);
  }
  reader.readAsText(files[0],'Windows-1251');
}

document.getElementById("puttyY").addEventListener('change',handleFileSelect,false);

window.onkeydown = function(event){
  if(event.keyCode !='119'){
    return;
  }
  var questionText = document.querySelectorAll('#question div.row h3')[1].innerHTML;
  var answsElements = document.querySelectorAll('div.answers fieldset span');
  var checkBoxes = document.querySelectorAll('div.answers fieldset input[type="checkbox"]');
  alert(questionText);
  
  var offset = GlobalText.indexOf(questionText);
  if(offset == -1){
    alert('ќтвет не найден');
    return;
  }
  var pointerStart = "ѕравильные ответы:";
  var pointerEnd = "Ќеправильные ответы:";
  var startOffset = GlobalText.indexOf(pointerStart,offset);
  var endOffset = GlobalText.indexOf(pointerEnd,offset);
  var resultAnswer = GlobalText.substring(startOffset+pointerStart.length,endOffset);
  alert(resultAnswer);
  for(i=0;i<answsElements.length;i++){
    alert(answsElements[i].innerHTML);
    if(resultAnswer.trim().indexOf(answsElements[i].innerHTML.trim()) ==-1){
      alert('Ќе совпало'+ i);
    }
    else{
      alert('Cовпало'+ i);
      checkBoxes[i].checked = true;
    }
  }
}
