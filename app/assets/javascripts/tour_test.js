// Define the tour!
var tour = {
  id: "hello-hopscotch",
  steps: [
    {
      title: "My Header",
      content: "This is the header of my page.",
      target: "tour-1",
      placement: "top"
    },
    {
      title: "My content",
      content: "Here is where I put my content.",
      target: "tour-2",
//      target: document.querySelector("#content p"),
      placement: "bottom"
    }
  ]
};

// Start the tour!
//hopscotch.startTour(tour);
//= button_tag 'tour', onclick: 'hopscotch.startTour(tour);', class: 'button success tiny'