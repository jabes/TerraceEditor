import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

private class Dialog extends Window {

  String message;
  String question;
  PApplet classObject;
  String callbackMethod;
  HashMap callbackMethodArgs;
  
  Method methodRequest;

  Dialog () {
    super(280, 150);
  }
  
  void init () {
    super.init();
    methodRequest = null;
    message = null;
    question = null;
    classObject = null;
    callbackMethod = null;
    callbackMethodArgs = null;
  }
  
  void reset () { init(); }
  void destroy () { reset(); }
  
  void redraw () {
    super.resetOffsets();
    if (super.isOpen) {
      if (message != null) {
        super.drawModalBox("Editor Message");
        super.drawModalBodyText(message);
        if (super.drawModalButton("Okay, close dialog") && mouse.wasClicked) destroy();
      } else if (question != null) {
        super.drawModalBox("Editor Confirmation");
        super.drawModalBodyText(question);
        if (super.drawModalButton("No, please stop!") == true && mouse.wasClicked) destroy();
        else if (super.drawModalButton("Yes, carry on") == true && mouse.wasClicked) {
          try {
            methodRequest = classObject.getClass().getMethod(callbackMethod, new Class[]{HashMap.class});
            methodRequest.invoke(classObject, callbackMethodArgs);
          } catch (SecurityException e) { error(e.getMessage());
          } catch (NoSuchMethodException e) { error(e.getMessage());
          } catch (IllegalArgumentException e) { error(e.getMessage());
          } catch (IllegalAccessException e) { error(e.getMessage());
          } catch (InvocationTargetException e) { error(e.getMessage());
          }
          destroy();
        }
      }
    }
  }
  
  void error (String msg) {
    println("Error: " + msg);
    showMessage("Error: " + msg);
  }
  
  void showMessage (String m) {
    message = m;
    super.isOpen = true;
  }
  
  void askQuestion (PApplet a, String q, String m, HashMap p) {
    classObject = a;
    question = q;
    callbackMethod = m;
    callbackMethodArgs = p;
    super.isOpen = true;
  }
  
}
