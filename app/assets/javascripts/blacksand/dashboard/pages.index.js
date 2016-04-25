$(function(){
	if($('#pages-index').length <= 0){
		return;
	}

	var $tree = $('#manage_menu').treeview({
		data: gon.pages,
		onNodeSelected: function(event, data) {
			$.get(data["href"]);
		}
	});

	var nodes = $tree.treeview('getSelected');
	// 默认 data 里的选中不会触发 selected event, 所以取消选中,再选中一次
	$tree.treeview('unselectNode', [nodes]);
	$tree.treeview('selectNode', [nodes]);
});