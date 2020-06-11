$(function(){
  	
  function buildHTML(message){
    // 「もしメッセージに画像が含まれていたら」という条件式
    if (message.image) {
      let html = `<div class="Mainchat__MessageList__Chat">
                    <div class="Mainchat__MessageList__Chat__User">
                      <div class="Username">
                        ${message.user_name}
                      </div>
                      <div class="Timestamp">
                        ${message.created_at}
                      </div>
                    </div>
                    <div class="Chatmessage">
                      <p>${message.text}</p>
                      <img class="Message__image" src="${message.image}">
                    </div>
                  </div>`
      return html;
    } else {
      let html = `<div class="Mainchat__MessageList__Chat">
                    <div class="Mainchat__MessageList__Chat__User">
                      <div class="Username">
                        ${message.user_name}
                      </div>
                      <div class="Timestamp">
                        ${message.created_at}
                      </div>
                    </div>
                    <div class="Chatmessage">
                    　<p>${message.text}</p>
                    </div>
                  </div>`
      return html
    }
  }

  $(".MessageForm").on("submit", function(e){
    e.preventDefault()
    let formData = new FormData(this);
    let url = $(this).attr('action');
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      let html = buildHTML(data);
      $('.Mainchat__MessageList').append(html);
      $('.Mainchat__MessageList').animate({ scrollTop: $('.Mainchat__MessageList')[0].scrollHeight});
      $('form')[0].reset();
      $('.send--btn').prop('disabled', false);
    })
    .fail(function(){
      alert('error');
    })
  })
});