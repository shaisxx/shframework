<#import "/macro/commonMacros.ftl" as commonMacros />
<html>
	<head>
		<title>${curMenu.title?if_exists}</title>
	</head>
	<body>
		<!-- BEGIN PAGE HEADER-->
		<@commonMacros.breadcrumbNavigation/>
		<!-- END PAGE HEADER-->
		<!-- BEGIN PAGE CONTENT-->
		<div class="row">
			<div class="col-md-12">
				<form name="listform" action="${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />/all/list" method="post" class="form-horizontal" role="form">
				    
				    <div class="portlet box green-seagreen">
						<div class="portlet-title">
							<div class="caption">
								搜索
							</div>
							<div class="tools">
								<a href="javascript:;" class="collapse"></a>
							</div>
						</div>
						
						<div class="portlet-body">
						    <div class="row ">
						    	<!--/span-->
						    	<div class="col-md-4">
									<div class="form-group ">
										<#if tableDesc?? && tableDesc?length gt 5>
											<#assign table_span_length=6 />
										<#else>
											<#assign table_span_length=5 />
										</#if>
										<label class="${'col-md-' + table_span_length} control-label">${tableDesc?if_exists}名称：</label>
										<div class="${'col-md-' + (12-table_span_length)}">
											<input class="form-control" name="_dc.title.3" type="text"
												value="<#if page.pageSupport.paramVo.map?exists>${page.pageSupport.paramVo.map['_dc.title.3']?if_exists?html}</#if>" />
										</div>
									</div>
								</div>
								<!--/span-->
								
								<!--/span-->
								<div class="col-md-3">
									<div class="form-group ">
										<label class="col-md-5 control-label">选用状态：</label>
										<div class="col-md-7">
							 				<@commonMacros.multiSelect staticlabel.status "search" "_dc.status" page.pageSupport.paramVo.map['_dc.status']/>
										</div>
									</div>
								</div>
								<!--/span-->
								
								<!--/span-->
								<div class="col-md-3">
									<div class="form-group ">
										<label class="col-md-5 control-label"> 执行标准：</label>
										<div class="col-md-7">
											<@commonMacros.multiSelect staticlabel.standard "search" "_dc.standard" "${page.pageSupport.paramVo.map['_dc.standard']?if_exists}"/>
										</div>
									</div>
								</div>
								<!--/span-->
								
								<!--/span-->
								<div class="col-md-2">
									<div class="form-group ">
										<div class="col-md-12">
											<button class="btn green-seagreen table-group-action-submit btn_search" type="submit" >搜索</button>
										</div>
									</div>
								</div>
								<!--/span-->
								
							</div>
							<!--row end-->
						</div>
						<!--portlet-body end-->
					</div>
				
					<div class="portlet box blue-steel">
						<div class="portlet-title">
							<div class="caption">
								${curMenu.title?if_exists}
							</div>
						</div>
						<div class="portlet-body">
						   
						    <div class="table-toolbar">
								<div class="row">
									<div class="col-md-6">
										<div class="btn-group">
											<a id="sample_editable_1_new" class="btn green-seagreen"
												href="${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />/0/add${page.pageSupport.paramVo.parm?if_exists?html}">
												新增
											</a>
										</div>
									</div>
								</div>
							</div>
							
							<table class="table table-striped table-bordered table-hover util-btn-margin-bottom-5" id="datatable_ajax">
								<thead>
								<tr role="row" class="heading">
								  <#if isContainCode =="YES">
									 <th class="sort_default" name="_dc.code" onclick="sortbyth(this)">${tableDesc}编码</th>
								  </#if>
									<th class="sort_default" name="_dc.title" onclick="sortbyth(this)">${tableDesc}名称</th>
									<th >选用状态</th>
									<th >执行标准</th>
									<th class="sort_default" name="_dc.priority" onclick="sortbyth(this)">排序</th>
									<th class="td_btn_width_2">操作</th>
								</tr>
								
								</thead>
								<tbody>
								    <#if page?exists && page.list?exists>
									<#list page.list as one>
									<tr>
		                  <#if isContainCode =="YES">
									     <td>${one.code?if_exists}</td>
									    </#if>
									    <td>
									    	<a  class="font-blue-steel" href="${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />/${one.id}/read${page.pageSupport.paramVo.parm?if_exists?html}" ><u>${one.title?if_exists}</u></a>
									    </td>
									    <td>
									   		<@commonMacros.multiSelect staticlabel.status "list" "status" "${one.status?default(1)}"/>
									   		<a class="font-blue" href="javascript:changeDictStatus(this, ${one.status?default(1)}, '${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />', ${one.id?if_exists}, '${page.pageSupport.paramVo.parm?if_exists?html}' );" >
									   		<@commonMacros.showStatusMark one.status />
									   		</a>
									    </td>
									    <td>
									        <@commonMacros.multiSelect staticlabel.standard "list" "standard" "${one.standard?default(-1)}"/>
									    </td>
									    <td >${one.priority}</td>
									    <td>
									    	<#--
									    	<a class="btn btn-xs btn-warning" href="${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />/${one.id}/read${page.pageSupport.paramVo.parm?if_exists?html}">
												查看</a>-->
									        <#if one.locked?default(1) == 0 >
									    	<a class="btn btn-xs green-seagreen" href="javascript:updateDictRecord('${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />', ${one.id}, '${page.pageSupport.paramVo.parm?if_exists?html}' );">
												修改</a>
											<a class="btn btn-xs default black" href="javascript:deleteDictRecord(this, '${contextPath}/dict/${tablePathPrefix}/${tableKey}/<@commonMacros.scope />', ${one.id}, '${page.pageSupport.paramVo.parm?if_exists?html}' );">
												删除 </a>
											</#if>
									    </td>
									</tr>
									</#list>
									</#if>
								</tbody>
							</table>
							 
							<@commonMacros.pagination/>
						</div>
					</div>
					
				</form>
				
		</div>
		<!-- END PAGE CONTENT-->
		
	</body>
</html>
