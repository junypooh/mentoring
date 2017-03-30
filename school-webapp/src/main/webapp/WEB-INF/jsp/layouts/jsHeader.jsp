<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<spring:eval expression="T(kr.or.career.mentor.util.HttpRequestUtils).TOMMS_APP_DOMAIN" var="TOMMS_APP_DOMAIN"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/slides.min.jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
<!--[if lte IE 8]>
<script type="text/javascript" src="/react/js/html5shiv.min.js"></script>
<script type="text/javascript" src="/react/js/es5-shim.min.js"></script>
<script type="text/javascript" src="/react/js/es5-sham.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/JSXTransformer.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.gallery.slide.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easing.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tmpl.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tmplPlus.js"></script>
<!-- bxSlider -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.bxslider.min.js"></script>

<script type="text/javascript">
mentor.contextpath = "${pageContext.request.contextPath}";
mentor.csrf_parameterName = "${_csrf.parameterName}";
mentor.csrf = "${_csrf.token}";
mentor.TOMMS_APP_DOMAIN = "${TOMMS_APP_DOMAIN}";
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.react.js"></script>
    <script type="text/javascript">
        if ( getCookie("modeView") == "PC" ) {
            document.write('<meta name="viewport" content="width=1024, user-scalable=yes">');
        } else {
            document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">');
        }

        /*
        var screenWidth = parseInt(screen.availWidth,10);
        var modeView = "Mobile";
        if ( screenWidth < 850 ) {
            if ($.cookie("modeView")) {
                modeView = $.cookie("modeView");
            }
            if( modeView == "PC" ) {
                document.write('<meta name="viewport" content="width=1024, user-scalable=yes">');
            } else {
                document.write('<meta name="viewport" content="user-scalable=no,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,width=device-width,target-densitydpi=medium-dpi">');
            }
        }
        $(function(){
            if ( screenWidth < 850 ) {
                if ( modeView == "PC" ) {
                    $("#ButtonModeView").css("display", "block").text("모바일버전").bind("click", function(){
                        $.cookie( "modeView", "Mobile" );
                        //top.location.replace(document.location.href.replace(/#.*$/g, ""));
                    });
                } else {
                    $("#ButtonModeView").css("display", "block").text("PC버전").bind("click", function(){
                        $.cookie( "modeView", "PC" );
                        //top.location.replace(document.location.href.replace(/#.*$/g, ""));
                    });;
                }
            }
        });
        */
    </script>