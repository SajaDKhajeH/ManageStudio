function getPhotoTopicsForCMBAsync(required, callBack) {
    const defaultOption = '<option value="0">انتخاب موضوع</option>';
    ajaxGet('/BasicData/PhotoTopics', function (items) {
        let options = items.map(item =>
            `<option value='${item.id}'>${item.title}</option>`
        ).join('');
        if (!required)
            options = defaultOption + options;
        if (callBack)
            callBack(options);
    });
}
function fillPhotoTopicsCMBAsync(cmbId, required, callBack) {
   getPhotoTopicsForCMBAsync(required, function (html) {
       $('#' + cmbId).html(html);
       if (callBack) {
           callBack();
       }
    });
}