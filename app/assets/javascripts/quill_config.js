// https://quilljs.com/docs/modules/toolbar/

var defaults = {
  theme: 'snow',
  modules: {
    toolbar: [
      [{ 'header': [2, 3, false] }],
      [{ 'align': [] }],
      ['bold', 'italic', 'underline','code'],['link'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      [{ 'indent': '-1'}, { 'indent': '+1' }],
//      [{ 'color': [] }, { 'background': [] }],
      ['clean']
    ],
    history: []
  }
};

//This is the global config object
Quilljs.setDefaults(defaults);