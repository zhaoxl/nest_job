/**
 ************************************************************
 * project 表单处理
 * author XinLiang
 * Mail 939898101@qq.com
 * ver version 1.0
 * time 2014-05-26
 * company : niaowo
 * Copyright : BSD License
 ************************************************************
 */
$(function($) {
    var isSaveHope = true;//是否保存过期望职位信息
    //验证=======================start
    $(".verification").each(function(){
        $(this).bind({
            blur:function(){

                var type = $(this).attr("data-type"),
                    value = $.trim($(this).val()),
                    error_id = $("#"+$(this).attr("error-id")),
                    bFail = false,
                    dataem = $(this).attr("data-em");

                $(this).css("border","1px solid #a0a0a0").next().removeClass("cur"+dataem).addClass(dataem);

                switch (type) {
                    case 'notnull':
                        if (value == '') {
                            bFail = true;
                        }
                        break;
                    case 'notchinese':
                        var notchinese = /[\u4E00-\u9FA5]/ig;
                        bFail = !notchinese.test(value);
                        break;
                    case 'pas':
                        var notpas = /^\w{6,16}$/;
                        bFail = !notpas.test(value);
                        break;
                    case 'email':
                        var emailReg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
                        bFail = !emailReg.test(value);
                        break;
                    case 'money':
                        var emailReg = /\b(?:[0-9]|[1-9][0-9]|1[0-4][0-9]|500)\b/;
                        bFail = !emailReg.test(value);
                        break;
                    case 'chinese':
                        var chineseReg = /^\s*([\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*|[a-zA-Z]{2,20}(\s+[a-zA-Z]{2,20})+)\s*$/;
                        bFail = (chineseReg.test(value) && /^\s*([\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*|[a-zA-Z][\sa-zA-Z]{3,63})\s*$/.test(value));
                }

                if(bFail){
                    error_id.css("display","block").html(error_id.attr("data-msg"));
                }else{
                    error_id.hide();
                }

                //显示提示信息
                if(!value && $(this).attr("data-noHide") != "1"){
                    $(this).prev().css("display","block");
                }

            },
            focusin:function(){
                if($(this).attr("data-noHide") == "1"){
                    return;
                }
                //隐藏提示信息
                var dataem = $(this).attr("data-em")
                $(this).css("border","1px solid #16a085").next().removeClass(dataem).addClass("cur"+dataem).prev().prev().hide();
            }
        });
    });
    //隐藏tip===============start
    $(".tipMsg").each(function(){
        $(this).click(function(){
            $(this).hide().next("input").focus();
        });
    });
    //登录切换==================start
    $("#loginTip").click(function(){
        $(".registerPanel").hide();
        $(this).hide();
        $("#registerTip").show();
        $("#registerBtn").parent().parent().hide();
        $("#loginBtn").parent().parent().show();
    });
    //注册切换==================start
    $("#registerTip").click(function(){
        $(".registerPanel").show();
        $(this).hide();
        $("#loginTip").show();
        $("#registerBtn").parent().parent().show();
        $("#loginBtn").parent().parent().hide();
    });
    //注册=====================start
    $("#registerBtn").click(function(){
        $("#mycaptcha").blur();
        $(".errorregister").prev().prev().blur();
        if($(".errorregister:visible").length != 0){
            return;
        }
        if($("#registerAgree:checked").length == 0){
            $( "#dialog").html("--->请同意《鸟窝用户协议》").dialog({
                modal:false,
                close:function(){}
            }).dialog( "open");
            return;
        }
        $( "#dialog").html("努力注册中···").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");


        $.ajax({
            dataType: "json",
            type: "post",
            url: "/accounts/registrations/ajax_create",
            data: {
                "account[email]": $.trim($("#myemail").val()),//邮箱
                "account[password]": $.trim($("#mypwd").val()),//密码
                "authenticity_token": $("meta[name='csrf-token']").attr("content"),
              /*  "account[password_confirmation]": $.trim($("#mypwdReport").val()),//确认密码*/
                "captcha": $("#mycaptcha").val() || "",//验证码
                "rememberme": $("#rememberMe:checked").length != 0 ? "1" : "0",//
                "user_type": $("#user_type:checked").length != 0 ? 1 : 2//用户类型
            },
            success: function(result) {
                if (result.status == "ok") {
                    $( "#dialog").html("注册成功，正在跳转").dialog({
                        modal:true
                    }).dialog("close");
                    //cookie记录注册  时间 =  24*60*60*365
                    Cookie.Set("registered", "1", 31536000, "/");
                    window.location.reload();
                } else {
                    $( "#dialog").dialog({
                        modal:true
                    }).dialog("close");
                    var _c = result.content;
                    if(_c.email){
                        $("#errorEmail").html(_c.email).css("display", "block")
                    }

                    if(_c.captcha){
                        $("#captchaError").html(_c.captcha).css("display", "block");
                        $("#captchaImg").click();
                    }
                }
            }
        });
    });
    $("#mycaptcha").bind({
        blur:function(){
            if(!$.trim($(this).val())){
                $(this).prev().show();
                $(this).next().next().next().css("display", "block");
            }else{
                $(this).next().next().next().hide();
            }
        },
        focusin:function(){
            if($.trim($(this).val())){
                $(this).next().next().next().hide();
            }

            $(this).prev().hide();
        }
    });
    //登录=====================start
    $("#loginBtn").click(function(){
        $("#mycaptcha").blur();
        $(".errorlogin").prev().prev().blur();
        if($(".errorlogin:visible").length != 0){
            return;
        }
        $( "#dialog").html("登录中···").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
        $.ajax({
            dataType: "json",
            type: "post",
            url: "/accounts/sessions/ajax_create",
            data: {
                "account[email]": $.trim($("#myemail").val()),//邮箱
                "account[password]": $.trim($("#mypwd").val()),//密码
                "captcha": $("#mycaptcha").val() || "",//验证码
                "rememberme": $("#rememberMe:checked").length != 0 ? "1" : "0",//记住我
                "authenticity_token": $("meta[name='csrf-token']").attr("content")
            },
            success: function(result) {
                if (result.status == "ok") {
                    $( "#dialog").html("登录成功，正在跳转").dialog({
                        modal:true
                    }).dialog("close");
                    window.location.reload();
                } else {
                    $( "#dialog").dialog({
                        modal:true
                    }).dialog("close");
                    var _c = result.content;
                    if(_c.email){
                        $("#errorEmail").html(_c.email).css("display", "block")
                    }

                    if(_c.captcha){
                        $("#captchaError").html(_c.captcha).css("display", "block");
                        $("#captchaImg").click();
                    }
                    if(_c.password){
                        $("#errorpassword").html(_c.password).css("display", "block");
                        $("#captchaImg").click();
                    }
                }
            }
        });
    });

    //如果没有登录，登录提示===========start
    $(".loginTip").each(function(){
        $(this).click(function(){
            var data_msgTip = $(this).attr("data-msgTip") || "--->请登录后再操作";
            $( "#dialog").html(data_msgTip).dialog({
                modal:true,
                close:function(){}
            }).dialog( "open");
        })
    });
    $("body").append('<div id="dialog" style="background-color: #27A695;color: #fff;text-align: center;font-size: 15px" title="Basic dialog">--->请登录后再操作</div>')
    $.ui.dialog.prototype._focusTabbable = function(){};
    $("#dialog").dialog({
        autoOpen:false,
        modal:false,
        height:100,
        title:"系统消息",
        show:{effect:'drop', direction:'up'},
        hide:{effect:'drop', direction:'down'},
        draggable:false,
        close: function() {
            $(".verification").first().focus();
        },
        resizable:false
    });
    $("body").append(
    '<!--选择城市-->'+
        '<div class="interviewBtns" id="searchCityPop">'+
        ' <a href="#" class="btnR">北京</a>'+
        ' <a href="#" class="btnR">上海</a>'+
        '  <a href="#" class="btnR">广州</a>'+
        '  <a href="#" class="btnR">深圳</a>'+
        ' <a href="#" class="btnR">成都</a>'+
        '   <a href="#" class="btnR">杭州</a>'+
        '   <a href="#" class="btnR">武汉</a>'+
        '   <a href="#" class="btnR">南京</a>'+
        '   <a href="#" class="btnR">其他</a>'+
        ' </div>');
    //选择城市====start
    $("#searchCityPop").dialog({
        autoOpen:false,
        modal:false,
        height:200,
        width:500,
        title:"选择城市",
        show:{effect:'drop', direction:'up'},
        hide:{effect:'drop', direction:'down'},
        draggable:false,
        close: function() {
            $(".verification").first().focus();
        },
        resizable:false
    });
    $("#js_searchCity").click(function(){
        $( "#searchCityPop").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
    });
    //搜索============start
    var searchJob = function(){
        var searchJobs = $.trim($("#searchJobs").val());
        if(searchJobs == "输入职位名称，如：销售" || !searchJobs){
            $( "#dialog").html("请输入要搜索的职位").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
            }).dialog( "open");
            setTimeout(function(){
                $( "#dialog").dialog( "close");
            },2000)
            return;
        }
        if(searchJobs){
            window.location.href="/posts/search?k=" + searchJobs;
        }

    }
    //搜索框
    $("#searchJobs").bind({
        blur:function(){
            var value = $.trim($(this).val());
            if(!value || value == "输入职位名称，如：销售"){
                $(this).val(" 输入职位名称，如：销售")
            }
        },
        focusin:function(){
            var value = $.trim($(this).val());
            if(value == "输入职位名称，如：销售"){
                $(this).val("")
            }
        },
        keyup:function(event){
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if(keycode == '13'){
                searchJob();
            }

        }
    });

   //发现标签搜索
    $(".f_btn").each(function(){
        $(this).bind({
            mouseout:function(){
                $(this).removeClass("f_current");
            },
            mouseover:function(){
                $(this).addClass("f_current");
            },
            click:function(){
                //执行搜索
                searchJob($.trim($(this).html()));
            }
        });
    });
    $("#searchJobBtn").click(function(){
        searchJob();
    });
    var hopeTags = "";
    //期望职位标签删除=====================start
    var deleteHope = function(){
        $(".deleteHope").unbind().each(function(){
            $(this).click(function(){
                //ajax 删除数据
                var _this = $(this).parent(),
                    text = _this.text().replace("×", "");
                hopeTags = hopeTags.replace(","+text).replace("undefined", "");

                _this.hide(0, function(){
                    _this.remove();
                });
            });
        });
    }

    deleteHope();

    //增加期望职位标签==============start
    $("#addHope").click(function(){
        var addHopeContent = $("#addHopeContent").val(),
            addHopePanelA = $("#addHopePanel a"),
            addHopePanelC = addHopePanelA.length,
            isreport = false,
            dataMax = $(this).attr("data-max");

        if(addHopePanelC >= 3 && dataMax!= "1"){
            $( "#dialog").html("期望职位·标签不超过3个").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
            }).dialog( "open");
            return;
        }

        if(!addHopeContent) {
            $( "#dialog").html("期望职位·标签不能为空").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
                }).dialog( "open");
            return;
        }

        addHopePanelA.each(function(){
            var con = $(this).html().replace('<i class="deleteHope" title="删除">×</i>', "");
            if(con == addHopeContent){
                isreport = true;
            }
        });
        if(isreport) {
            $( "#dialog").html(dataMax!= "1" ? "期望职位·标签不能重复" : "职位关键词不能重复").dialog({
                modal:true,
                close: function() {$("#addHopeContent").focus();}
            }).dialog( "open");
            return;
        }
        hopeTags += "," + addHopeContent;
        $("#addHopePanel").append('<a href="javascript:void(0)" style="display: none">'+ addHopeContent +'<i class="deleteHope" title="删除">×</i></a>').children().last().show();
        deleteHope();
    });
    $("#addHopeContent").keyup(function(){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            $("#addHope").click();
        }
    });
    //保存期望标签·城市
    $("#saveHopes").each(function(){
        $(this).bind({
            mouseup:function(){
                $(this).css({"padding-left":"0px","padding-top":"0px"});
                var addHopePanelA = $("#addHopePanel a"),
                    addHopePanelC = addHopePanelA.length,
                    cityHopes = $.trim($("#cityHopes").val());

                if(addHopePanelC == 0){
                    $( "#dialog").html("请添加·期望职位").dialog({
                        modal:true,
                        close:function(){
                            $("#addHopeContent").focus();
                        }
                    }).dialog( "open");
                    return;
                }

                if(!cityHopes){
                    $( "#dialog").html("请添加·期望城市").dialog({
                        modal:true,
                        close:function(){
                            $("#cityHopes").focus();
                        }
                    }).dialog( "open");
                    return;
                }

                //ajax保存期望值
                $.ajax({
                    dataType: "json",
                    type: "post",
                    url: "index/ajax_update_hope",
                    data: {
                        "tags": hopeTags.replace(/(^[,]+)|([,]+$)/g, ""),//职位
                        "hope_city": cityHopes,//城市
                        "authenticity_token": $("meta[name='csrf-token']").attr("content")
                    },
                    success: function(result) {
                        if (result.status == "ok") {
                            $( "#dialog").html("保存成功，正在跳转").dialog({
                                modal:true
                            }).dialog("close");
                            window.location.reload();
                        } else {
                            $( "#dialog").html("保存失败"+result.content);
                        }
                    }
                });
            },
            mousedown:function(){
                $(this).css({"padding-left":"1px","padding-top":"1px"});
            }
        });
    });
    //刷新验证码
    $(".updateCaptcha").each(function(){
        $(this).click(function(){
            $("#captchaImg").attr("src", "/captcha?i="+new Date().getTime());
        });
    });


    //分享成功
    $(".share").each(function(){
        $(this).click(function(){
            $( "#dialog").html("分享成功").dialog({
                modal:true,
                close:function(){}
            }).dialog( "open");
        });
    });

    //检测用户是否注册过，如果注册过显示登录框，否则显示注册框
    if(Cookie.Get("registered") == "1"){
        //显示 登录
        $("#loginTip").click();
    }

    //用户协议
    $("body").append("<div style='display: none;background-color: #27A695;color: #fff;text-align: left;font-size: 15px' id='userAgreementPop'>"+
        "<p>欢迎光临“鸟窝”，在使用“鸟窝”之前请您仔细阅读本用户协议。如果您对用户协议的任何条款表示异议，您可以选择不使用“鸟窝”。登录并使用“鸟窝”，则意味着您自愿遵守本协议，并在使用过程中服从“鸟窝”的统一管理。</p>"+
        "<p>一、 协议目的：</p>"+
        "<p>本协议作为“鸟窝”与用户签订的服务协议，用以约束用户使用本网站及鸟窝为用户提供约定服务的行为，双方均应遵守本协议条款并履行相关义务。</p>"+
        "<p>二、用户的权利义务：</p>"+
        "<p>1、在完成“鸟窝”注册程序后您将成为“鸟窝”合法用户，享受“鸟窝”提供的服务，同时用户需保证具有相应的民事行为能力，并在完全同意本协议的情形下完成注册。</p>"+
        "<p>2、用户承诺在“鸟窝”发布的简历或信息均符合国家有关法律法规规定，并保证其真实性、完整性、准确性，不侵害任何第三方的权利。</p>"+
        "<p>3、用户承诺使用“鸟窝”仅用于用户自身招聘或求职目的，不得从事任何其他活动，不得发布除招聘信息或自身简历外的其他资料。</p>"+
        "<p>4、用户对在“鸟窝”上得到、浏览的任何信息（包括但不限于本网站发布的招聘、求职信息、简历资料等）仅可做自身招聘或求职使用，不得用于其它商业或非商业目的。</p>"+
        "<p>5、用户在本网站注册成功后需对帐号及密码的使用及安全承担全部责任。用户不得将帐号转借他人使用，用户应对以其帐号进行的所有活动承担责任。</p>"+
        "<p>6、用户应对使用“鸟窝”的一切行为承担责任，如因用户行为给其他第三方或“鸟窝”造成任何损失的，用户应承担赔偿责任。</p>"+
        "<p>7、用户在“鸟窝”实施了违法行为，导致第三方投诉（包括但不限于第三方以发等形式指控“鸟窝”侵权，提起诉讼、仲裁，或使“鸟窝”面临相关主管机关的审查或质询），“鸟窝”有权先暂停用户的使用。用户应在收到通知后，以自己名义出面与第三方协商、应诉或接受相关主管机关审查或质询，承担所有费用，并赔偿因此给“鸟窝”造成的全部损失。</p>"+
        "<p>三、“鸟窝”的权利义务：</p>"+
        "<p>1、“鸟窝”应为用户提供优质的服务，并接受用户的监督及合理建议。</p>"+
        "<p>2、用户在“鸟窝”发布的信息如有违反法律规定，本协议约定或“鸟窝”认为属于不适合发布的信息的，鸟窝有权进行修改、删除。</p>"+
        "<p>3、用户同意因网络原因、“鸟窝”进行网络调整、正常的系统维护升级等造成的本网站无法正常访问，“鸟窝”不承担任何责任。</p>"+
        "<p>4、“鸟窝”网站（包括但不限于网站上的所有工具、应用、功能等）作为“鸟窝”为用户提供信息的平台，用户同意并保证使用以上内容均出于自愿并已得到有效授权，不得侵犯任何第三方的权益。“鸟窝”对用户的使用行为不承担任何责任。</p>"+
        "<p>5、“鸟窝”可能会提供与其他互联网网站或资源进行链接。对于前述网站或资源是否可以利用，“鸟窝”不予担保。因使用或依赖上述网站或资源所造成的损失或损害，“鸟窝”也不负担任何责任。</p>"+
        "<p>四、信息的公开：</p>"+
        "<p>1、用户同意招聘企业或个人有权对用户向本网站递交的简历及相关信息进行查询并使用。对于因此而引起的任何法律纠纷，“鸟窝”不承担任何法律责任。</p>"+
        "<p>2、用户了解并同意其在本网站发布的任何信息，包括但不限于个人简历、个人资料、求职信息、联系方式等，均有可能被本网站的访问者浏览或被其他第三方抄录用于商业或非商业性目的。对于因任何第三方使用有关信息所引发的纠纷，“鸟窝”将不予承担任何责任。</p>"+
        "<p>五、知识产权：</p>"+
        "<p>本网站所有内容、设计、图标、图表、文字及其组合、产品、技术、程序等知识产权均归“鸟窝”所有。</p>"+
        "<p>六、违约责任：</p>"+
        "<p>如用户有以下行为视为违约，“鸟窝”有权随时采取停止服务，删除信息，取消会员资格，解除本协议，要求用户赔偿一切损失等行动。同时“鸟窝”已收取的服务费（如有）将不予退还。</p>"+
        "<p>1、用户的行为违反法律规定的。</p>"+
        "<p>2、用户的行为违反本协议承诺、约定的。</p>"+
        "<p>3、用户的行为侵犯任何第三方权益的。</p>"+
        "<p>4、用户的行为不利于“鸟窝”的。</p>"+
        "<p>七、协议的变更：</p>"+
        "<p>“鸟窝”保留随时修正、更新本服务条款的权利。一旦发生相关修订或更新，“鸟窝”会将修订和更新的内容及时在本页面发布，用户如认为变更无法接受，应该停止使用本网站相关服务。如果继续使用“鸟窝”相关服务的，则视为用户接受变更条款并愿意受其约束。</p>"+
        "<p>八、不可抗力：</p>"+
        "<p>如因不可抗力导致本协议无法履行的，双方互不承担责任。</p>"+
        "<p>九、法律适用：</p>"+
        "<p>本协议的订立、生效、解释、执行、管辖、争议的解决均适用中华人民共和国法律。</p>"+
        "<p>十、其他：</p>"+
        "<p>1、本协议自用户登录使用“鸟窝”起生效，长期有效。</p>"+
        "<p>2、“鸟窝”保留在法律允许范围内对本协议的最终解释权。</p>"+
        "</div>");
    $("#userAgreementPop").dialog({
        autoOpen:false,
        modal:false,
        height:600,
        width:900,
        title:"《鸟窝用户协议》",
        show:{effect:'drop', direction:'up'},
        hide:{effect:'drop', direction:'down'},
        draggable:false,
        close: function() {
            $(".verification").first().focus();
        },
        resizable:false
    });
    $("#userAgreement").click(function(){
        $( "#userAgreementPop").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
    });

    //找回密码弹框
    $("body").append('<div id="forgetPasswordPop" style="background-color: #27A695;color: #fff;text-align: left;font-size: 20px" title="Basic dialog">'+
        '<div style="position: relative;top:15%;">邮箱地址：<input type="text" id="forgetPasswordContent">'+
        '<b style="font-size: 12px"> 请输入您注册时用的邮箱</b><br /><br />'+
        '<input style="width: 155px;height: 46px;cursor:pointer;font-size: 16px;line-height: 46px;clear: both;float: left;background: #019875;color: #fff;border: none;text-align: center;" type="button" value="找回密码" id="actionFindPassword"></div>'
        +'</div>')
    $("#forgetPasswordPop").dialog({
        autoOpen:false,
        modal:false,
        height:200,
        width:500,
        title:"找回密码",
        show:{effect:'drop', direction:'up'},
        hide:{effect:'drop', direction:'down'},
        draggable:false,
        close: function() {
            $(".verification").first().focus();
        },
        resizable:false
    });

    $("#forgetPassword").click(function(){
        $( "#forgetPasswordPop").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
    });

    $("#actionFindPassword").click(function(){
        $( "#forgetPasswordPop").dialog({
            modal:true,
            close:function(){}
        }).dialog( "close");
        $( "#dialog").html("找回密码邮件已发送到您的邮箱<br/>请注意查收").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
    });
    //发布职位 getContent
    $("#positionIssue").click(function(){
        //验证
        $(".verification").blur();
        //查看职位详情
        var _content = $.trim(myEditor.getContent());
        if(_content){
            $(".jobMore").hide();
        }else{
            $(".jobMore").show();
        }
        if($(".error:visible").length != 0){
            return;
        }
        $( "#dialog").html("正在发布...").dialog({
            modal:true
        }).dialog("open");
        $("#addHopeContenthidden").val(hopeTags.replace(/(^[,]+)|([,]+$)/g, ""));
        $("#new_post").submit();
    });
    var uploading = false;
    //上传照片
    $("#myimage").length > 0 && new AjaxUpload("#myimage", {
        action: '/accounts/profile/ajax_update_logo',
        name:'file',
        //选择后自动开始上传
        autoSubmit:true,
        data:{
            "authenticity_token": $("meta[name='csrf-token']").attr("content")
        },
        //返回Text格式数据
        responseType: "json",
        //上传的时候按钮不可用
        onSubmit : function(filename,ext){
            if(uploading) return;
            //设置允许上传的文件格式
            if (!(ext && /^(jpg|png|jpeg|gif|JPG|PNG|JPEG|GIF)$/.test(ext))){
                myAlert('未允许上传的文件格式!');
                // cancel upload
                return false;
            }
            $( "#dialog").html("上传头像...").dialog({
                modal:true
            }).dialog("open");
            uploading = true;
        },
        //上传完成后取得文件名filename为本地取得的文件名，msg为服务器返回的信息
        onComplete: function(filename,json) {
            uploading = false;
            console.log(json);
            if(json.status == "ok"){
                $(".myimgs").attr("src", json.content);
                $( "#dialog").html("上传成功");
                setTimeout(function(){
                    $( "#dialog").dialog({
                        modal:true
                    }).dialog("close");
                },1500);
            }else{
                $( "#dialog").html(json.content);
                setTimeout(function(){
                    $( "#dialog").dialog({
                        modal:true
                    }).dialog("close");
                },1500);
            }
        }
    });
    //保存基本资料
    $("#saveInfo").click(function(){
        $(".verification").blur();
        if($(".error:visible").length != 0){
            return;
        }
        $( "#dialog").html("保存基本资料...").dialog({
            modal:true
        }).dialog("open");
        $("form").eq(0).submit();
    });

    //职位列表效果
    $(".selectcurrent").bind({
        mouseover:function(){
            $(this).addClass("current");
        },
        mouseout:function(){
            $(this).removeClass("current");
        }
    });
   //发起面试
    $(".initiateInterviewBtn").each(function(){
        $(this).click(function(){
            $(".initiateInterviewPop").show();
        });
    })
    $(".closeinitiateInterviewBtn").each(function(){
        $(this).click(function(){
            $(".initiateInterviewPop").hide();
        });
    })


});

//收藏职位
function addCollect(_this){
    var jobID = $(_this).attr("jobid"),
        isc = $(_this).attr("isc");
    if(isc == "1"){
        $( "#dialog").html("已收藏").dialog({
            modal:true,
            close:function(){}
        }).dialog( "open");
        setTimeout(function(){
            $( "#dialog").dialog({
                modal:true,
                close:function(){}
            }).dialog( "close");
        },2000);
        return;
    }
    $( "#dialog").html("收藏中...").dialog({
        modal:true,
        close:function(){}
    }).dialog( "open");
    $.ajax({
        dataType: "json",
        type: "post",
        url: "/accounts/favorites/ajax_create",
        data: {
            "id": jobID,//职位
            "item_type": "post",
            "authenticity_token": $("meta[name='csrf-token']").attr("content")
        },
        success: function(result) {
            if (result.status == "ok") {
                $( "#dialog").html("收藏成功").dialog({
                    modal:true,
                    close:function(){}
                }).dialog( "open");
                setTimeout(function(){
                    $( "#dialog").dialog({
                        modal:true,
                        close:function(){}
                    }).dialog( "close");
                },2000);
                $(_this).html("已 收 藏").attr("isc","1");
            } else {
                $( "#dialog").html(result.content).dialog({
                    modal:true,
                    close:function(){}
                }).dialog( "open");
            }
        }
    });

}