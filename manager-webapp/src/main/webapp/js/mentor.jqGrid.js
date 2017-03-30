// 테이블 resize 함수
/*
* @param string gridId 사이즈를 변경할 그리드의 아이디
* @param string divId 그리드의 사이즈의 기준을 제시할 div 의 아이디
* @param string width 그리드의 초기화 width 사이즈
*/
function resizeJqGridWidth(gridId, divId, width) {
    $grid = $("#"+gridId);
    $wrapGridDiv = $("#"+divId);
    // window에 resize 이벤트를 바인딩 한다.
    $(window).bind('resize', function() {
        // 그리드의 width 초기화
        $grid.setGridWidth(width, false);
        // 그리드의 width를 div 에 맞춰서 적용
        $grid.setGridWidth($wrapGridDiv.width() , true); // Resized to new width as per window
    }).trigger('resize');
}

// 테이블 초기화 함수
/*
* @param String gridId 그리드의 아이디
* @param ArrayJson colModel grid colModel 값
* @param Int rowNum 초기 보여질 게시물 갯수
* @param boolean check 게시물 앞에 체크박스
* @param Int Grid height px 단위
*/
function initJqGridTable(gridId, divId, width, colModels, check, height, options) {

    var gridHeight = height;
    if(height == null || typeof height == 'undefined') {
        gridHeight = 'auto';
    }
    $grid = $("#"+gridId);

    var defaults = {
        datatype: "local",
        height: gridHeight,
        colModel: colModels,
        multiselect: check,	// 게시물 앞에 체크박스
        loadui: 'disable',
    };

    var settings = $.extend( {}, defaults, options );
    $grid.jqGrid(settings);
    // 데이터 없을 경우 임의의 colModel 적용 후 다시 변경 되지 않기 때문에 reloadGrid 해준다.
    /*colModels[0].cellattr = function(rowId, val, rawObject, cm, rdata) { return ' colspan=1'}
    $grid.jqGrid('setGridParam', {'multiselect' : check});
    $grid.jqGrid('setGridParam', {'colModel' : colModels});*/
    resizeJqGridWidth(gridId, divId, width);
}

// 테이블 Data 바인딩 함수
/*
* @param String gridId 그리드의 아이디
* @param ArrayJson data
* @param String emptyTxt 결과 없을 시 보여줄 텍스트
*/
function setDataJqGridTable(gridId, divId, width, data, emptyTxt, height) {

    $grid = $("#"+gridId);
    $('#' + gridId + '-grid-empty-data').remove();
    $grid.jqGrid('clearGridData');

    if(height != null && typeof height != 'undefined') {
        $grid.jqGrid('setGridHeight', height);
    }

    var rowId ;
    for(var i = 0 ; i < data.length ; i++) {
        if(typeof data[i].gridRowId != "undefined" && data[i].gridRowId != null) {
            rowId = data[i].gridRowId;
        } else {
            rowId = i;
        }
        $grid.jqGrid('addRowData', rowId, data[i]);
    }

    if(data.length == 0) {
        $grid.jqGrid('setGridHeight', 'auto');
        $('#gbox_'+gridId).after('<div id="' + gridId + '-grid-empty-data" class="empty-data">' + emptyTxt + '</div>');
/*
        var oldColModel = $grid.jqGrid('getGridParam', 'colModel');
        var emptyColModel = oldColModel.map(function(item, index) {
            if(index == 0) {
                item.name = 'text';
                item.cellattr = function(rowId, val, rawObject, cm, rdata) { return ' colspan="'+ oldColModel.length +'"'}
            }
            return item;
        });
        var emptyData = {text : emptyTxt};

        $grid.jqGrid('setGridParam', {'multiselect' : false});
        $grid.jqGrid('setGridParam', {'colModel' : emptyColModel});
        $grid.jqGrid('addRowData', 0, emptyData);
*/
    }

    resizeJqGridWidth(gridId, divId, width);
}

// 테이블 Data 삭제 함수
/*
* @param String gridId 그리드의 아이디
* @param rowId Data Object의 rowId
*/
function delDataJqGridTable(gridId, rowId) {
    $grid = $("#"+gridId);
    $grid.jqGrid('delRowData', rowId);
}