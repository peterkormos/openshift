package datatype;

public class MainPageNotice {

    public enum NoticeType {
        OK, Error, Warning
    };

    private NoticeType type;

    private String text;

    public MainPageNotice(NoticeType type, String text) {
        this.type = type;
        this.text = text;
    }

    public String getText() {
        return text;
    }

    public NoticeType getType() {
        return type;
    }

    public void setText(String text) {
        this.text = text;
    }

    public void setType(NoticeType type) {
        this.type = type;
    }

}
