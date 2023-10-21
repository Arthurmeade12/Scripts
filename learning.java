import java.util.Scanner;
class learning {
  public static void main(String[] args) {
    System.out.println("CALCULATOR");
    int a, b, remainder;
    String wish, response;
    Scanner input = new Scanner(System.in);
    //for (boolean again = true; again == true; ) {
    wow: // label. you can break or continue to labels.
    do {
      System.out.print("First integer : ");
      a = input.nextInt();
      System.out.print("Second integer : ");
      b = input.nextInt();
      System.out.println("Sum : " + (a + b));
      System.out.println("Difference : " + (a - b));
      System.out.println("Product : " + (a * b));
      System.out.println("Quotient : " + (a / b));
      remainder = a % b;
      if (remainder != 0) {
        System.out.println(b + " did not divide into " + a +  " evenly.");
        System.out.println("Remainder : " + remainder);
      }
      else {
        System.out.println("No remainder.");
      }
      System.out.print("Again ? (y/n) ");
      wish = input.next();
      //again = (wish == "y") ? true : false;
      switch (wish) {
      case "y":
        again = true;
        break;
      case "n":
        again = false;
        break;
      default:
        System.out.println("Your response was not 'y' or 'n'. Exiting.");
        again = false;
        break;
      }
    } while(again);
    System.out.print("Are you satisfied with this calculator ? (y/n) ");
    response = input.next();
    input.close();
    switch (response) {
    case "y":
      System.out.println("Great!");
      break;
    case "n":
      System.out.println("I'm sorry you didn't like this product.");
      break;
    default:
      System.out.println("I'm sorry, I didn't understand your response.");
      break;
    }
    System.out.println("Thank you. Your feedback is important.");
  }
}
