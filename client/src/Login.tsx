import React, { Component } from 'react';
import {Container, Row, Col, FormControl, Button, Form, Card } from 'react-bootstrap';

class Login extends Component{

  constructor(props: any) {
    super(props);
    this.state = {
    }
  }

  render(){
      return(
        <Container>

          <Row>
            <Col sm lg md={{ span: 10, offset: 1 }}>

                <Card style={{ width: 500 }}>
                  <Card.Body>
                    <Card.Title> Login </Card.Title>
                    <Card.Text>
                      <Form>

                        <Form.Group controlId="formBasicEmail">
                          <Form.Label>Email address</Form.Label>
                          <Form.Control type="email" placeholder="Enter email" />
                          <Form.Text className="text-muted">
                            We'll never share your email with anyone else.
                          </Form.Text>
                        </Form.Group>

                        <Form.Group controlId="formBasicPassword">
                          <Form.Label>Password</Form.Label>
                          <Form.Control type="password" placeholder="Password" />
                        </Form.Group>

                        <Button variant="primary" type="submit">
                          Submit
                        </Button>

                      </Form>
                    </Card.Text>

                  </Card.Body>
                </Card>

            </Col>
          </Row>

        </Container>
    )
  }

}

export default Login;
