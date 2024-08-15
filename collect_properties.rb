def collect_properties(email_template)
    
    user_regex = /\{\{\s*user\.(\w+)\s*\}\}/
    event_regex = /\{\{\s*event\.(\w+)\s*\}\}/
    event_loop_regex = /\{%.*event\.(\w+)\s*%}/
  
    
    user_properties = []
    event_properties = []
  
    # Scan the email template for user properties
    email_template.scan(user_regex) do |match|
      user_properties << match.first unless user_properties.include?(match.first)
    end
  
    # Scan the email template for event properties
    email_template.scan(event_regex) do |match|
      event_properties << match.first unless event_properties.include?(match.first)
    end
  
    # Scan the email template for event properties in loops (Products)
    email_template.scan(event_loop_regex) do |match|
      event_properties << match.first unless event_properties.include?(match.first)
    end
  
    # Create and return the hash with the properties
    {
      user_properties: user_properties,
      event_properties: event_properties
    }
  end
  
  
  email_template = <<-EMAIL
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
  <html data-ember-extension="1" dir="auto">
    <head>
      <style type="text/css">
        body {
          font-family: arial, sans-serif;
          color: #222;
          line-height: 1.4285;
        }
        
        p {
          color: #222;
        }
        
        ul li {
          margin-left: 15px;
        }
        
        img {
          max-width: 100%;
        }
  
      </style>
    </head>
    <body aria-disabled="false">Hello {{ user.first_name }},
      <br>
      <br>
      <br>Visit our shop for the following deals:
      <br>
      <br>
      <br>{% for product in event.products %}
      <br>- <a href="{{product.url}}">{{product.item_name}}</a>
      <br>{% endfor %}
      <br>
      <br>And as part of our special customer appreciation event... next time you visit our brick and mortar location in {{ user.city }}, be sure to use the following coupon code while checking out for an additional 20% discount:
      <br>{{ event.coupon_code }}
      <br>
      <br>Thanks!</body>
  </html>
  EMAIL
  
  
  puts collect_properties(email_template).inspect
  