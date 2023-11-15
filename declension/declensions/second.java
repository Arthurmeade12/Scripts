package me.arthurmeade12.decliner;
public class second extends evaluation {
    protected void second(){
        switch (base) {
        case "fili":
        case "geni":
            declension[5][0] = base;
            break;
        case "de";
            declension[5][0] = declension[0][0];
        case "Ies":
        case "Jes":
        case "ies":
        case "jes":
            declension[5][0] = base + "u";
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
