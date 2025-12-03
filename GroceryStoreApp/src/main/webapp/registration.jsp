<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="form-wrapper">
            <div class="form-header">
                <i class="fas fa-shopping-cart"></i>
                <h1>Grocery Store</h1>
                <h2>Create Account</h2>
            </div>
            
            <!-- Display error or success messages -->
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                String successMessage = (String) request.getAttribute("successMessage");
                
                if (errorMessage != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= errorMessage %>
                </div>
            <% 
                }
                
                if (successMessage != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= successMessage %>
                </div>
            <% 
                }
            %>
            
            <form action="RegistrationController" method="post" class="registration-form">
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">
                            <i class="fas fa-user"></i> Full Name
                        </label>
                        <input type="text" id="fullName" name="fullName" 
                               placeholder="Enter your full name">
                               <span id="nameempt" ></span>
                               
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i> Email
                        </label>
                        <input type="email" id="email" name="email" 
                               placeholder="Enter your email" >
                               <span id="emailvery"></span>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="username">
                            <i class="fas fa-user-circle"></i> Username
                        </label>
                        <input type="text" id="username" name="username" 
                               placeholder="Choose a username">
                               <span id="usernamecheck" ></span>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">
                            <i class="fas fa-lock"></i> Password 
                        </label>
                        <input type="password" id="password" name="password" 
                               placeholder="Enter password" >
                               <span id="passchar"> </span>
                               
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">
                            <i class="fas fa-lock"></i> Confirm Password 
                        </label>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               placeholder="Re-enter password">
                      		  <span id="passvery" ></span>
                              
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone"></i> Phone
                        </label>
                        <input type="tel" id="phone" name="phone" 
                               placeholder="Enter phone number">
                               <span id="phonevery" ></span>
                               
                    </div>
                </div>
              
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-user-plus"></i> Register
                </button>
                
                <div class="form-footer">
                    <p>Already have an account? <a href="login.jsp">Login here</a></p>
                </div>
            </form>
        </div>
    </div>
    
    
    <script>
    	document.getElementById("fullName").addEventListener("blur",checkname)
    	document.getElementById("fullName").addEventListener("keypress",namechar)
    	document.getElementById("phone").addEventListener("keypress",phonechar)
     	document.getElementById("phone").addEventListener("blur",phonecount)
    	document.getElementById("password").addEventListener("blur",checkpass)
     	document.getElementById("password").addEventListener("keyup",checkpasschar)
  	
     	document.getElementById("confirmPassword").addEventListener("blur",checkpass)
     	document.getElementById("email").addEventListener("blur",checkemail)
     	document.getElementById("username").addEventListener("keyup",checkusername)
     	
     	let usernameTimeout;
     	function checkusername (){
     		clearTimeout(usernameTimeout);
    		var checkusername = document.getElementById("username").value;
    	    var checkSpan = document.getElementById("usernamecheck");
    	    
    	    if (checkusername.length < 4) {
    	        checkSpan.innerHTML = "Username must be at least 4 characters";
    	        checkSpan.style.color = "red";
    	        return;
    	    }

    		usernameTimeout = setTimeout(function(){
    			fetch('CheckusernameController?checkusername=' + encodeURIComponent(checkusername)).then(response=>response.json()).then(data =>{
    				if (data.available){
    					checkSpan.innerHTML="User Name Available";
    					checkSpan.style.color="green";
    					
    				}
    				else {
    					checkSpan.innerHTML="User Name Already Taken";
    					checkSpan.style.color="red";
    				}
    				
    			});
    		}, 500);
    		
    	}

     	
     	function checkemail(){
    		var mail = document.getElementById("email").value;
    		mail = mail.trim().toLowerCase();
    		if (!mail.endsWith("@gmail.com")){
    			document.getElementById("emailvery").innerHTML = "Mail Must End With @gmail.com"
    			document.getElementById("emailvery").style.color="red";
    		}
    		
    		if (mail==""){
    			document.getElementById("emailvery").innerHTML = "Mail Cannot Be Empty";
    			document.getElementById("emailvery").style.color="red";

    		}
    	}
     	
     	
     	function checkpasschar(){
     		var pass = document.getElementById("password").value;
    		var repass = document.getElementById("confirmPassword").value;
    		if (pass.length < 4) {
    	        document.getElementById("passchar").innerHTML = "Password must be at least 4 characters";
    	        document.getElementById("passchar").style.color = "red";
    	       return;
    	    }
    		if (pass.length >= 4) {
    	        document.getElementById("passchar").innerHTML = "";
    	        document.getElementById("passchar").style.color = "";
    	       return;
    		
    		}
     	}
     	
  	
    	
    	function checkpass(){
    		var pass = document.getElementById("password").value;
    		var repass = document.getElementById("confirmPassword").value;
    		
    
    		if (pass!=repass){
    			document.getElementById("passvery").innerHTML = "Password and Confirm Password Should be same";
    			document.getElementById("passvery").style.color="red";
    		}	
    		
    		if (pass==repass){
    			document.getElementById("passvery").innerHTML = "Password and Confirm Password Matched";
    			document.getElementById("passvery").style.color="green";

    		}	
    		
    		
    	}
    	
    	function namechar(event) {
            var ch = event.which;
            if (!((ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || (ch == 32) || (ch == 8))) {
                event.preventDefault();
            }
        }
    	
    	function phonechar(event) {
            var ch = event.which;
            if (!(ch >= 48 && ch <= 57)) {
                event.preventDefault();
            }
        }
    	
    	function phonecount(){
    		var phoneval = document.getElementById("phone").value;
    		if (phoneval==""){
    			document.getElementById("phonevery").innerHTML = "Phone Number Cannot Be Empty";
    			document.getElementById("phonevery").style.color="red";
    			}
    		 else if (phoneval.length != 10) {
    		     document.getElementById("phonevery").innerHTML = "Phone Number Must Be 10 Digits";
    		     document.getElementById("phonevery").style.color = "red";
    		    }
    		 else {
    		      document.getElementById("phonevery").innerHTML = "Valid Phone Number";
    		      document.getElementById("phonevery").style.color = "green";
    		    }
    	}
    	

    	function checkname (){
    		var namevalue = document.getElementById("fullName").value;
    		if (namevalue==""){
    			document.getElementById("nameempt").innerHTML = "Name Cannot Be Empty";
    			document.getElementById("nameempt").style.color="red";

    		}
    	}
    	
    	
    
    </script>
    
</body>
</html>
