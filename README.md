## Hi，🤔
<!--[if IE 8]>         <div class="lt-ie9"> <![endif]-->
<style type="text/css">  
* {box-sizing:border-box}
body, html {padding:0; margin:0} 
body {background:#232323; color:#fff}
.opaque {position:absolute; top:0; left:0; right:0; bottom:0; opacity:0; background:#d2d6f1;}
.lt-ie9 .opaque {display:none;}
.feature {position:fixed; top:0; z-index:0; width:100%; padding-top:50%; background: url(http://s3.nikecdn.com/pass/NikeBasketball/LeBron_Poster.jpg) center center no-repeat;
    -webkit-background-size:250%;
       -moz-background-size:250%;
         -o-background-size:250%;
            background-size:250%;
    -webkit-box-shadow: 0 -50px 20px -20px #232323 inset;
       -moz-box-shadow: 0 -50px 20px -20px #232323 inset;
            box-shadow: 0 -50px 20px -20px #232323 inset;
  }
.content {position:relative; z-index:1; padding-top:45%; width:90%; margin:0 auto;}

@media only screen and (min-width:36.250em) {
  .content {width:60%; padding-top:35% }
} 
</style>
<script>
$(function(){
    zoom = $('.feature').css('background-size')
    zoom = parseFloat(zoom)/100
    size = zoom * $('.feature').width();
    $(window).on('scroll', function(){
      fromTop = $(window).scrollTop();
      newSize = size - (fromTop/3);
      if (newSize > $('.feature').width()) {
          $('.feature').css({
              '-webkit-background-size': newSize,
              '-moz-background-size': newSize,
              '-o-background-size': newSize,
              'background-size': newSize,
              '-webkit-filter':'blur('+ 0 + (fromTop/100) + 'px)',
              'opacity': 1 - ((fromTop / $('html').height()) * 1.3)
          });
      }
    });
});

$(function (){
    var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
    var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);

    if (isChrome || isSafari) {
    } else {
        $('.feature').append('<div class="opaque"></div>');
        $(window).on('scroll', function(){
            var opacity = 0 + ($(window).scrollTop()/5000);
            $('.opaque').css('opacity', opacity);
        });
    }
});
</script>
<div class="feature"></div>
<div class="content">
  <h2>Heading</h2>
  <p>Lorem ipsum dolor sit amet, consectetur adipiscfing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. </p>
  <p>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. </p>
  <p>Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. </p>
  <h2>Heading</h2>
  <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. </p>
  <p>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. </p>
  <p>Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. </p>
</div>
<!--[if IE 8]>         </div> <![endif]-->




<p align="center">
  <img src="https://user-images.githubusercontent.com/5679180/79618120-0daffb80-80be-11ea-819e-d2b0fa904d07.gif" width="27px">
  <br><br>
  <samp>
I'm Ben. A Golang Developer mostly foucs Microservice，web technology，VM And Cloud computing.
     <br><br>Contact me on <a href="https://twitter.com/Njutree">Twitter</a> or <a href="mailto:njutree@gmail.com">Send an Email</a>
  </samp>
</p>

<!--
**foreversmart/foreversmart** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...
- 👯 I’m looking to collaborate on ...
- 🤔 I’m looking for help with ...
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...
-->
