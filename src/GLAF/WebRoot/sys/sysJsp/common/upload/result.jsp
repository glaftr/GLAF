<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="baseSrc.common.upload.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<base target="_self" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link href="./css/fileUpload.css" type="text/css" rel="stylesheet"/>
<link href="./css/site.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript">
<!--
function submitUpload() {
  var fileId = document.getElementById("fileId").value;
  var returnArray = new Array(fileId,getValues('file'));
  window.returnValue = returnArray; 
  window.close();
}

function getValues(name)
{
  var inputObj = document.getElementsByName(name);
	var values = '';
	for (var i = 0; i < inputObj.length; i++)
	{
	  if (inputObj.item(i).value != '')
		{
		  values += inputObj.item(i).value + ',';
		}
	}
	if (values.substring(values.length - 1) == ",")
	{
	  values = values.substring(0, values.length - 1);
	}
	return values.replace(/\r\n/ig, "%0A");
}
//-->
</script>
<title>文件上传结果</title>
</head>
<body>
<form id="fileUploadForm" name="fileUploadForm" method="post" action="" onsubmit="return submitUpload()">
  <div id="resultPanel">
    <div><span>上传文件:</span></div>
    <%
	String fileId = (String)request.getAttribute("fileId");
	FileUploadStatus fUploadStatus=BackGroundService.getStatusBean(request);
  int num = fUploadStatus.getUploadFileUrlList().size();
	boolean isFailed = false;
	for(int i=0;i<num;i++){
		String fileName=(String)fUploadStatus.getUploadFileUrlList().get(i);
		String url=fUploadStatus.getBaseDir()+"/"+fileName;
	%>
    <div><label><%=fileName%></label>
        <input name="file" type="hidden" value="<%= fileName %>" />
         <input id="fileId" name="fileId" type="hidden" value="<%= fileId %>" />
    </div>
    <%
	}
	if (fUploadStatus.getStatus().indexOf("错误")>=0){
	  isFailed = true;
	%>
    <div id='errorArea'><span>错误信息:<%=fUploadStatus.getStatus() %></span></div>
    <%	
	}
	else if (fUploadStatus.getCancel()){
	  isFailed = true;
	%>
    <div id='normalMessageArea'><span>用户取消了本次上传,可选择重新上传</span></div>
    <%
	}
	BeanControler.getInstance().removeUploadStatus(request.getRemoteAddr());
	
%>
    <%
  if (isFailed || num == 0) {
%>
    <div align="center"><a href="<%=request.getContextPath()%>/sys/sysJsp/common/upload/fileUpload.jsp">重新上传</a>
      &nbsp;
      <input name="close" type="button" class="button" value="关闭" onclick="javascript:self.close()" />
    </div>
    <%
  } else {
%>
    <div align="center">
      <input name="Submit" type="submit" class="button" value="提交" />
    </div>
    <%
  }
%>
  </div>
</form>
<%
  if (!isFailed && num > 0) {
%>
<script type="text/javascript">
<!--
  submitUpload();
//-->
</script>
<%
	}
%>
</body>
</html>