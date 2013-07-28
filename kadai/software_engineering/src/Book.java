public class Book {
    // The fields.
    private String author;
    private String title;
    private int pages;

    /**
     * Set the author and title fields when this object
     * is constructed.
     */
    public Book(String bookAuthor, String bookTitle)
    {
        author = bookAuthor;
        title = bookTitle;
    }

    public Book(String bookAuthor, String bookTitle, int bookPages) {
        this(bookAuthor, bookTitle);
        pages = bookPages;
    }

    public String getAuthor() {
        return author;
    }

    public String getTitle() {
        return title;
    }

    public int getPages() {
        return pages;
    }

    public void setPages(int pages) {
        this.pages = pages;
    }

    public void printAuther() {
        System.out.println(author);
    }

    public void printTitle() {
        System.out.println(title);
    }

    public void printDetails() {
        printAuther();
        printTitle();
        System.out.println(pages);
    }

    public static void main(String[] args) {
        Book b1 = new Book("Larry Wall", "Programming Perl 4th Edition");
        b1.printDetails();

        Book b2 = new Book("Effective Perl Programming", "Joseph N. McAdams", 504);
        b2.printDetails();

        b1.setPages(504);
        if (b1.getPages() == b2.getPages()) {
            System.out.println("ok");
        }
    }

}
