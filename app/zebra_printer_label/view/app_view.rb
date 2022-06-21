class ZebraPrinterLabel
  module View
    class AppView
      include Glimmer::UI::CustomShell
    
      ## Add options like the following to configure CustomShell by outside consumers
      #
      # options :title, :background_color
      # option :width, default: 320
      # option :height, default: 240
      option :greeting, default: 'Hello, World!'
  
      ## Use before_body block to pre-initialize variables to use in body
      #
      #
      before_body do
        @display = display {
          on_about do
            display_about_dialog
          end
          
          on_preferences do
            display_preferences_dialog
          end
        }
      end
  
      ## Use after_body block to setup observers for widgets in body
      #
      # after_body do
      #
      # end
  
      ## Add widget content inside custom shell body
      ## Top-most widget must be a shell or another custom shell
      #
      body {
        shell {
          # Replace example content below with custom shell content
          minimum_size 420, 240
          image File.join(APP_ROOT, 'icons', 'windows', "Zebra Printer Label.ico") if OS.windows?
          image File.join(APP_ROOT, 'icons', 'linux', "Zebra Printer Label.png") unless OS.windows?
          text "Zebra Printer Label - App View"
        
          grid_layout
          label(:center) {
            text <= [self, :greeting]
            font height: 40
            layout_data :fill, :center, true, true
          }
          
          menu_bar {
            menu {
              text '&File'
              
              menu_item {
                text '&Preferences...'
                
                on_widget_selected do
                  display_preferences_dialog
                end
              }
            }
            menu {
              text '&Help'
              
              menu_item {
                text '&About...'
                
                on_widget_selected do
                  display_about_dialog
                end
              }
            }
          }
        }
      }
  
      def display_about_dialog
        message_box(body_root) {
          text 'About'
          message "Zebra Printer Label #{VERSION}\n\n#{LICENSE}"
        }.open
      end
      
      def display_preferences_dialog
        dialog(swt_widget) {
          grid_layout {
            margin_height 5
            margin_width 5
          }
          
          text 'Preferences'
          
          group {
            row_layout {
              type :vertical
              spacing 10
            }
            
            text 'Greeting'
            font style: :bold
            
            [
              'Hello, World!',
              'Howdy, Partner!'
            ].each do |greeting_text|
              button(:radio) {
                layout_data {
                  width 160
                }
                
                text greeting_text
                selection <= [self, :greeting, on_read: ->(g) { g == greeting_text }]
                
                on_widget_selected do |event|
                  self.greeting = event.widget.getText
                end
              }
            end
          }
        }.open
      end
    end
  end
end
