class testing {
    public static String last(String abc, int a) {
        // Need to evaluate abc twice
        String exec =  abc + ".substring(" + abc + ".length()-" + a;
        return (exec);
    }
    public static void main(String args[]) {
        String result = last("agri", 1);
        System.out.println(result);
    }
}
