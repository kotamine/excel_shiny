$(document).on('shiny:inputchanged', function(event) {
       if (event.name === 'num_feeders') {
         trackingFunction(['trackEvent', 'Modeling Input',
          'changed Number of Feeders', event.name, event.value]);
       }
       if (event.name === 'num_calves') {
         trackingFunction(['trackEvent', 'Modeling Input',
         	'changed Number of Calves', event.name, event.value]);
       }
        if (event.name === 'days_on_feeder') {
         trackingFunction(['trackEvent', 'Modeling Input', 
         	'changed Days on Feeder', event.name, event.value]);
       }
     });