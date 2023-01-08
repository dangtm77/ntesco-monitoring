class StringHelper {
  static String toShortName(String value) { 
    if (value != "" && value.length > 0) {
      var arr = value.split(' ');
      if (arr.length <= 2)
        return value;  
      else if (arr.length > 2)
        return arr[arr.length - 2] +' '+ arr[arr.length - 1];
      else
        return value;
    } else
      return value;
  }
}
