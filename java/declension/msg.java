package me.arthurmeade12.decliner;
public class msg {
    public static boolean debug = false;
    public static void out(String msg) {
        System.out.printf("\033[1;34m==>\033[0m \033[1;37m%s\033[0m%n", msg);
    }
    public static void warn(String msg) {
        System.out.printf("\033[1;33m==>\033[0m \033[1;37mWARNING:\033[0m \033[1;37m%s\033[0m%n", msg);
    }
    public static void die(String msg, int code) {
        System.out.printf("\033[1;31m==>\033[0m \033[1;37mERROR:\033[0m \033[1;37m%s\033[0m%n\033[0;31mAborting ...\033[0m%n", msg);
        System.exit(code);
    }
    public static void die(String msg) {
        System.out.printf("\033[1;31m==>\033[0m \033[1;37mERROR:\033[0m \033[1;37m%s\033[0m%n", msg);
    }
    public static void debug(String msg) {
        if (debug == true) {
            System.out.printf("\033[1;33m==>\033[0m \033[1;37mDEBUG:\033[0m \033[1;37m%s\033[0m%n", msg);
        }
    }
}
