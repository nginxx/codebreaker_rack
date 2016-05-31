/**
 * Created by user on 19.05.16.
 */
$(document).ready(function () {
    if ($('.modal').length) {
        $('#game_over_modal').modal({backdrop: 'static', keyboard: false})
    }

    $('.btn-info').click(function () {
        $('.hint p').css({display: 'block'})
    })
});