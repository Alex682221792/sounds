class Validators {
  static String? minLength(String text, int size){
    if(text.length >= size){
      return null;
    }
    return "Minimun $size char";
  }
}