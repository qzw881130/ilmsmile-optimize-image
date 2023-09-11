local chunk, eof = ngx.arg[1], ngx.arg[2]
if ngx.ctx.buffered == nil then
    ngx.ctx.buffered = {}
end

ngx.log(ngx.INFO, "is_subrequest:" .. (ngx.is_subrequest and 'Y' or 'N'))

if chunk ~= "" and not ngx.is_subrequest then
    table.insert(ngx.ctx.buffered, chunk)
    ngx.arg[1] = nil
end

if eof then
    local whole = table.concat(ngx.ctx.buffered)
    ngx.ctx.buffered = nil

    local domain = ngx.var.scheme .. '://' .. ngx.var.host
    if(ngx.var.server_port ~= '80' and ngx.var.server_port ~= '443') then
        domain = domain .. ':' .. ngx.var.server_port
    end

    ngx.log(ngx.INFO, "site: usa-lua:" .. domain)


    whole = string.gsub(whole, '(.jpg)', ".jpg.webp")
    whole = string.gsub(whole, '(.png)', ".png.webp")
    whole = string.gsub(whole, '(.jpeg)', ".jpeg.webp")
    whole = string.gsub(whole, '(<div class="footer_copyrights">.-</div>)', "")
    whole = string.gsub(whole, '(<span class="f16 news_rec_time">.-</span>)', "")

    ngx.log(ngx.INFO, "Host: " .. ngx.req.get_headers()["Host"])
    if string.match(ngx.req.get_headers()["Host"], "localhost") then 
        whole = string.gsub(whole, '(<link type="text/css" rel="stylesheet" href=")', '<link type="text/css" rel="stylesheet" href="' .. ngx.header.cssbaseurl)
        whole = string.gsub(whole, '(<script type="text/javascript" src=")', '<script type="text/javascript" src="' .. ngx.header.jsbaseurl)
    else

    end


    -- whole = string.gsub(whole, '(<div class="intro__benefits benefits "><div class="benefits__powered"><p class="benefits__by">.-</svg>Quality Motorhome Hire</li></ul></div>)', '')
    -- whole = string.gsub(whole, '(<div class="process__benefits benefits "><div class="benefits__powered"><p class="benefits__by">.-</svg>Quality Motorhome Hire</li></ul></div>)', '')
    -- whole = string.gsub(whole, '(https://www.motorhomehireperth.com)', domain)

    -- whole = string.gsub(whole, '(.search__bar{margin)', '.search__bar{display:none;margin')
    -- whole = string.gsub(whole, '(.search__bar{display:flex;)', '.search__bar{display:none;')

    -- whole = string.gsub(whole, '(.powered{font%-size:1.3125rem;line%-height:1.2380952381;display:flex;)', '.powered{font-size:1.3125rem;line-height:1.2380952381;display:none;')
    -- whole = string.gsub(whole, '(<p class="cta__text">%sLearn how to book through Camplify or look at our Motorhomes.</p>)', '')

    ngx.arg[1] = whole
    ngx.arg[2] = true

    ngx.log(ngx.INFO, "length:" .. string.len(whole))
end