# Texture

* Phân chia công việc chia công việc cho background thead để xử lý, chuẩn bị trước cho main thread để xử lý.
* Đơn vị cơ bản là Node (ASDisplayNode)
* Với giao diện cỏ thể scroll giao diện được chia làm 3 trạng thái:
	* Preload: nơi xa nhật trước khi hiển thị, nơi thu thập dữ liệu từ server hoặc thao tác với dữ liệu
	* Display: thực hiện tác vụ xử lý giải mã ảnh, text,…
	* Visible: Node được hiển thị trên màn hình
* Ta có thể custom độ dài của trạng thái Preload và display (tính theo màn hình; vd: display có độ dài 2 màn hình), khi tăng độ dài lên thì dung lượng cũng tăng.
