$(function(){
	if($('#navigations-index').length <= 0){
		return;
	}

	dragula([$('#nav-table tbody')[0]]).on('drop', function(){
		console.log('drop')

		// 保存顺序
		var newOrders = $('#nav-table tbody').children().map(function(){
				return $(this).data('navigation-id')
			})
			.get();

		var update_url = $('#nav-table tbody').data('update-url');
    $.post(update_url, {navigations: newOrders})
	});
});