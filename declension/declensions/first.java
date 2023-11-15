package me.arthurmeade12.decliner;
public class first extends evaluation {
    protected void first(){
        switch (base) {
        case "de":
        case "fili":
            declension[2][1] = base + "abus";
            declension[4][1] = base + "abus";
            break;
        default:
            break;
        }
    }
    protected void complete(String[][] array){
        System.out.println(array[0][0] + "  " + array[0][1]);
        System.out.println(array[1][0] + " " + array[1][1]);
        System.out.println(array[2][0] + " " + array[2][1]);
        System.out.println(array[3][0] + " " + array[3][1]);
        System.out.println(array[4][0] + "  " + array[4][1]);
        if (print_vocatives_and_locatives) {
            System.out.println(array[5][0] + "  " + array[5][1]);
            System.out.println(array[6][0] + " " + array[6][1]);
        }
    }
}
